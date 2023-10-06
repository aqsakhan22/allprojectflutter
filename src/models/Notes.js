// step 1 is Define scheme for data coming from database Note-> id , userid , title , content , dateaddes
const db = require('mongoose');
const Schema = db.Schema;
const noteSchema=Schema({
 
    id:{
        type:String,
        unique:true,
        required:true
    },
    userid:{
        type:String,
        required:true
    },
    title:{
        type:String,
        required:true
    },
    content:{
        type:String,
       
    },
    dateAdded:{
        type:Date,
         default:Date.now 
    }
    
});

module.exports=  db.model("Note",noteSchema);