const fs = require("fs");

let datToScad = (ipath, opath)=>{
    const content = fs.readFileSync(ipath, 'utf8');
    const lines = content.split(/\r?\n/);

    let res = "points = [";


    let firstLine = true;
    for(let line of lines){
        if(firstLine){
            firstLine = false;
        }else{
            const trimmed = line.trim();
            if(!trimmed) continue;
    
            const parts = trimmed.split(/\s+/);
            if(parts.length >= 2){
                const x = parseFloat(parts[0]) || 0, y=parseFloat(parts[1]) || 0;
                res += "["+x+","+y+"],\n";
            }
        }
    }
    res +=  "];";
    
    fs.writeFileSync(opath, res);
};

const args = process.argv;
console.log(args);
if(args[2]){
    datToScad("./dat/"+args[2]+".dat","./scad/"+args[2]+".scad");
}