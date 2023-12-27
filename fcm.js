const FCM= require("fcm-node");
const fcm=new FCM("AAAAfwD7Tcs:APA91bEjd4LfY5nzfQhx9kc31IelY8iCDzfhUfvrD9YgPcNd0FQJUCG7xe2te_pC3MDt9dPtYrnUWZalx45AN8IDlnIyxbPUNiJEiXrJ7L3snl28Mjw9ocev3WN_zJGPRTQjCID9Ntxh");
const android="eyM5iaNQSQqoGtzWC1iGLM:APA91bEYgW5dBp8lqgAq__83YdPrqEIX1jo2vcz2EopbZhOG5tzoxBk7S0O6Zy2NvR91SrD0-ejEkHwDWnKzW1QB2zQQz-b_1tAlSslZBbMuE5mnDE7Zr7_qx9JKSjB8PkSvUbGsiv_B";
const ios="dxga98d3dUwUufrnRp8Nm_:APA91bHuA2yCVuHxZtmCxJx3u7cs4tksDTGwNqhNebvBeR2Bgy-sinZ116FrBtydmsC9trJbf15zTf4EqJ7N9f16lZfYzrTYDbOwKZJsubKpRdVxoNKym9lwdkPOFfJyDfGUrSMjnHxo";
const myPhone="f_dGTikRSYiTX87l9d8OAG:APA91bE9rp4wKuX2o0sWTRemt3IKybkGgHhIbOY-HPaQxSOugT204v670fzKOfp3Sc4M4bKZCqgaxzr-ClWpyILh7FaAJVk8zEmi21hs3ateSw3raDyFjHi9xlcjYObFM3E80wvG0S3u";


const message={
    notification:{
        title:"notification title",
        body:"notification body ",
    },
    data:{
        report_id:'260793',
        title:"data title ",
        body:"data body ",
    }
     ,    
    apns:{
        payload:{
            aps:{
             "mutable-content":"1"
            }
        }
    },
    android: {
        "priority": "high"
    },
    to:android
};
// ANDROID
// cWF71ZNDTyS2Kwj58RRxwa:APA91bFBTDl0ukCP0uzx2LGkrmJYPc5gAA2H_sS-74GS--QLfjMpWQ3cpbgVA_5hClVq2aigzIXQ_0CXPNhu0UlAKFA6jbnldGHLtvKWka4BdIMBibsc-Ilg0yZGUo_0FerraIhi8zJE
// ios
// eZQBMdCl1kIttIJhZtO1ra:APA91bHAt1noebWXv_7ukk0e1rRX0IVQkp-kWAQkdMY8IwQUZCtUjxVqYh4Gd584Y4Cw6tCHdi7sinLGzSBXpj6j5F0JL9m7QTD_Dr8COa03i1zeYKqMGOVdMsGZH-Svtz4ARZKUt-1m
fcm.send(message,function(err,response){
    
    if(err){
        console.log("Error in FCM",err);
    }
    else{
        console.log("Successfully send",response);
    }
});

// https://ashizetz.medium.com/guide-to-implement-push-notifications-for-android-and-ios-using-node-js-51cbbec9e418
//https://medium.com/@Bisal.r/push-notification-using-firebase-and-node-js-7508f61fa25c