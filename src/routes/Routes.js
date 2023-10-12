
const express = require('express');
const router=express.Router();
const Note=require('./../models/Notes');



router.get('/alllist',async function (req,res)  {
  console.log("Node js List api ");

    const notes=await Note.find();
    // res.json(notes);
    const response={message:"list of notes",error:"0",data:notes};
    res.json(response);

    });

    router.post('/add',async function (req,res)  {
       
      // res.setHeader('Content-Type', 'application/json');

         try{
          
            if(res.statusCode == 200){
                const newNote=new Note({
                    id:req.body.id ,
                    userid:req.body.userid,
                    title:req.body.title,
                    content:req.body.content,
                });

              await newNote.save();    
          
              const response={message:"User has been Created",error:"0"};
              // res.send(response);
              res.json(response);
              // console.log("Error is",res);
    
            }
            else{
             const response={message:"User No Created",error:"1"};
             res.json(response);
             }
         
         }
         catch(e){
            switch(e['code']){
              case 11000:
                const response={message:"User Already Exist",error:"1"};
                return res.json(response);
                breaks;
            };
           

       //  res.send(res.status.name,res.statusMessage,res.statusCode);

         }
        

//    res.json(req.body);

 
        });

        router.post('/list', async function (req,res)  {
          console.log("Single note ",req.body);
            const notes=await Note.find({userid:req.body.userid});
            const response={message:"Fetching Notes",error:"0",data:notes};
            res.json(response);
        
             });

             router.post('/delete',async function (req,res)  {
              console.log("Delete api response is",req.body);
 
                 const delNotes=await Note.deleteOne(
                    {
                        id:req.body.id
                    }
                 );
             
        
              const response={message:"User has been Deleted",error:"0"};
              res.json(response);



    
     

//    res.json(req.body);


        });


module.exports=router;