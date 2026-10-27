const {spawn} = require('child_process');

let foil = "";
let re = "40000";
let mach = "0.08";
let N = "2";
let aMin = "-20";
let aMax = "20";
let aStep = "0.5";

const args = process.argv;
console.log(args);
if(args[2]){
    foil = args[2];
}else{
    return -1;
}
if(args[3]){
    re = args[3];
}
if(args[4]){
    mach = args[4];
}
if(args[5]){
    N = args[5];
}
if(args[6]){
    aMin = args[6];
}
if(args[7]){
    aMax = args[7];
}
if(args[8]){
    aStep = args[8];
}

let ASEQ = [
    // "ALFA 0",
    // "ASEQ -"+aStep+" "+aMin+" "+aStep,
    // "ALFA 0",
    // "ASEQ 0 "+aMax+" "+aStep,
];
for(let i=parseFloat(aMin);i<parseFloat(aMax);i+=parseFloat(aStep)){
    ASEQ.push("ALFA "+i);
}

const commands = [
    "PLOP",
    "G",
    "",
    // "LOAD ./dat/"+foil+".dat",
    "NACA 1403",
    "GDES",
    "UNIT",
    "",
    "PANE",
    "PPAR",
    "N 500",
    "T 0.05",
    "",
    "",
    "OPER",
    "VPAR",
    "N",
    N,
    "",
    "VISC",
    "Re",
    re,
    "m",
    mach,
    "PACC",
    "./polar/N"+N+"/RE"+re+"/"+foil+"_polar.txt",
    "",
    ASEQ.join("\n"),
    "",
    "QUIT"
].join("\n") + "\n";

const xfoil = spawn("xfoil");
xfoil.stdin.write(commands);
xfoil.stdin.end();
xfoil.stdout.on('data',data=>{
    //process.stdout.write(data);
});
xfoil.stderr.on('data',data=>{
    //process.stderr.write(`Error: ${data}`);
});
xfoil.on('close', (code)=>{
    console.log("Xfoil closed: " + code);
});