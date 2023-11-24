const FCM= require("fcm-node");
const fcm=new FCM("AAAAfwD7Tcs:APA91bEjd4LfY5nzfQhx9kc31IelY8iCDzfhUfvrD9YgPcNd0FQJUCG7xe2te_pC3MDt9dPtYrnUWZalx45AN8IDlnIyxbPUNiJEiXrJ7L3snl28Mjw9ocev3WN_zJGPRTQjCID9Ntxh");
const message={
    
    notification:{
        title:"Hello world",
        body:"Notification body"
    },
    to:"fnTWPCaFTNuY01tZTXItgN:APA91bG1URgDZcNX7ZKW3u8Ij1rlFyr5gvc3M1asJ9c358fw1v6lI5LmzRadHVlDIHs_0R6pFNQJIkdkDFKM8F7gS0sTKuLdmdZhwf4r5eQaqkHQvtGIlotAvVZLqLhKCgMH_7h-sNtD"
};


//fdA3mICLoUjllwYlxICGJt:APA91bECGQm9vxmIywIqef9F3y1IuqIkT1S4xGEZh0V3OmPHLrAp9GQt1wyGpiEqPMZU5-lhau6bUm_VZTDd6yuJImxwwI2ucFvenI9mWGJXaV0e9aAI_WrhCR2Cp-Rj6J7JsHgOgfB7
fcm.send(message,function(err,response){
    if(err){
        console.log("Error in FCM",err);
    }
    else{
        console.log("Successfully send",response);
    }
});

// https://ashizetz.medium.com/guide-to-implement-push-notifications-for-android-and-ios-using-node-js-51cbbec9e418
