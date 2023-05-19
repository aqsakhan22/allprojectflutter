package com.example.flutterdevelopment


//import android.Manifest
//import android.content.Context
//import android.content.pm.PackageManager
//import android.location.LocationListener
//import android.location.LocationManager
//import android.os.Bundle
//import androidx.core.app.ActivityCompat
//import io.flutter.embedding.engine.plugins.activity.ActivityAware
//import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import android.Manifest
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageManager
import android.location.Location
import android.location.LocationListener
import android.location.LocationManager
import android.os.BatteryManager
import android.os.Bundle
import android.os.Handler
import android.widget.Toast
import androidx.core.app.ActivityCompat
import io.flutter.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.EventChannel.StreamHandler
import io.flutter.plugin.common.MethodChannel


//import io.flutter.plugin.common.PluginRegistry.Registrar



//import io.flutter.plugin.common.EventChannel.StreamHandler
//import io.flutter.plugin.common.EventChannel.EventSink
//import io.flutter.plugin.common.MethodCall
//import io.flutter.plugin.common.PluginRegistry.Registrar
//import io.flutter.plugin.common.MethodChannel.MethodCallHandler
//import io.flutter.embedding.engine.plugins.FlutterPlugin




class MainActivity: FlutterActivity(){

    private val channelName="AqsaChannel";
    private var count = 1
    private var handler: Handler? = null


    private var attachEvent: EventSink? = null
    private val runnable: Runnable = object : Runnable {
        override fun run() {
            val TOTAL_COUNT = 100
            if (count > TOTAL_COUNT) {
                attachEvent!!.endOfStream() // ends the stream
            } else {

                // we need to values for LinearProgressIndicator
                val percentage = count.toDouble() / TOTAL_COUNT
                attachEvent!!.success(percentage)
                Log.w("counter", "\nParsing From Native:  $percentage")
            }
            count++
            handler?.postDelayed(this, 200)
        }
    }


    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        var channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName);
        // New
        val eventChannel = EventChannel(flutterEngine.dartExecutor.binaryMessenger, "chargingModule")

        val locationChannel = EventChannel(flutterEngine.dartExecutor.binaryMessenger, "locationStatusStream")
        val message = EventChannel(flutterEngine.dartExecutor.binaryMessenger, "message")
        val counterChannel = EventChannel(flutterEngine.dartExecutor.binaryMessenger, "com.chamelalaboratory.demo.flutter_event_channel/eventChannel")

        val backgroundService = EventChannel(flutterEngine.dartExecutor.binaryMessenger, "backgroundService")


        channel.setMethodCallHandler { call, result ->
            var args = call.arguments as Map<String, String>;
            var message = args["message"];
            if (call.method == "showToast") {
                val SendmessagetoDart = getMessage();
                if (SendmessagetoDart.isNotEmpty()) {
                    result.success(SendmessagetoDart);

                }
                Toast.makeText(this, message, Toast.LENGTH_LONG).show();

            }


            else {
                result.notImplemented();
            }
        }

     message.setStreamHandler(
            object : StreamHandler {
                override fun onListen(args: Any?, events: EventSink) {

                    events.success(true)

                }

                override fun onCancel(args: Any) {
                    print("cancel")
                    Log.d("message", "cancelling listener for message")
                }
            }
        )


        counterChannel.setStreamHandler(
            object : StreamHandler {
                override fun onListen(args: Any?, events: EventSink) {

                    Log.w("onListen", "Adding listener")
                    attachEvent = events
                    count = 1
                    handler = Handler()
                    runnable.run()

                }

                override fun onCancel(args: Any) {
                    Log.w("cancel", "Cancelling listener");
                    handler?.removeCallbacks(runnable);
                    handler = null;
                    count = 1;
                    attachEvent = null;
                    System.out.println("StreamHandler - onCanceled: ");
                }
            }

        )

        backgroundService.setStreamHandler(
            object : StreamHandler {
                override fun onListen(args: Any?, events: EventSink) {

                    Log.w("onListen", "Adding listener")
                    attachEvent = events

                }

                override fun onCancel(args: Any) {
                    Log.w("cancel", "Cancelling listener");
                    handler?.removeCallbacks(runnable);
                    handler = null;
                    attachEvent = null;
                    System.out.println("StreamHandler - onCanceled: ");
                }
            }

        )

eventChannel.setStreamHandler(MyStreamHandler(context))
        locationChannel.setStreamHandler(
           object : StreamHandler{
               override fun onListen(arguments: Any?, p1: EventChannel.EventSink) {
                   val listener = object : LocationListener {
                       override fun onLocationChanged(location: Location) {

                           p1.success("onLocationChanged");
                       }

                       override fun onStatusChanged(provider: String, status: Int, extras: Bundle) {
                           p1.success("onStatusChanged");
                       }

                       override fun onProviderEnabled(provider: String) {

                           p1.success("onProviderEnabled");
                       }

                       override fun onProviderDisabled(provider: String) {
                           print("location onProviderDisabled ${provider}");
                           p1.success("onProviderDisabled");
                       }

                   }

                   val locationManager = getSystemService(Context.LOCATION_SERVICE) as LocationManager
                   if (ActivityCompat.checkSelfPermission(
                           context,
                           Manifest.permission.ACCESS_FINE_LOCATION
                       ) != PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(
                           context,
                           Manifest.permission.ACCESS_COARSE_LOCATION
                       ) != PackageManager.PERMISSION_GRANTED
                   ) {
                       // TODO: Consider calling
                       //    ActivityCompat#requestPermissions
                       // here to request the missing permissions, and then overriding
                       //   public void onRequestPermissionsResult(int requestCode, String[] permissions,
                       //                                          int[] grantResults)
                       // to handle the case where the user grants the permission. See the documentation
                       // for ActivityCompat#requestPermissions for more details.
                       return
                   }
                   locationManager.requestLocationUpdates(LocationManager.GPS_PROVIDER,
                       2000,
                       10f, listener)
               }

               override fun onCancel(arguments: Any?) {
                   TODO("Not yet implemented")
               }

           }
        )

    }


    private fun getMessage() : String{
        return  "Message from Kotlin code";
    }



}


class MyStreamHandler(private val context: Context) : EventChannel.StreamHandler {
    private var receiver:BroadcastReceiver? =null
    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        // int a in java a: int in kotlin
        if(events == null) return
        receiver=initReceiver(events)
        context.registerReceiver(receiver,IntentFilter(Intent.ACTION_BATTERY_CHANGED))
    }

    private fun initReceiver(events: EventChannel.EventSink): BroadcastReceiver? {
        return  object : BroadcastReceiver() {
            override fun onReceive(context: Context?, intent: Intent?) {
               val status= intent?.getIntExtra(BatteryManager.EXTRA_STATUS,-1)
                when(status){
                    BatteryManager.BATTERY_STATUS_CHARGING -> events.success("Battery is charging")
                    BatteryManager.BATTERY_STATUS_FULL -> events.success("Battery is full")
                    BatteryManager.BATTERY_STATUS_DISCHARGING -> events.success("Battery is discharding")

                }
            }

        }

    }

    override fun onCancel(arguments: Any?) {
       context.unregisterReceiver(receiver)
        receiver=null

    }




}




