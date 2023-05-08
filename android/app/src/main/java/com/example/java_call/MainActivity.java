package com.example.java_call;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import com.termux.shared.termux.TermuxConstants;
import com.termux.shared.termux.TermuxConstants.TERMUX_APP.RUN_COMMAND_SERVICE;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import android.content.Intent;
import android.os.Bundle;
import androidx.annotation.NonNull;
import android.app.PendingIntent;
import android.util.Log;
import com.example.java_call.PluginResultsService;



public class MainActivity extends FlutterActivity{
    private static final String CHANNEL = "Calling";
    String LOG_TAG = "MainActivity";
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    super.configureFlutterEngine(flutterEngine);
      new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
          .setMethodCallHandler(
            (call, result) -> {
              if(call.method.equals("its")) {
                  Oncall();}
              }
          );
    }


public void Oncall(){
    String LOG_TAG = "MainActivity";

Intent intent = new Intent();
intent.setClassName(TermuxConstants.TERMUX_PACKAGE_NAME, TermuxConstants.TERMUX_APP.RUN_COMMAND_SERVICE_NAME);
intent.setAction(RUN_COMMAND_SERVICE.ACTION_RUN_COMMAND);
intent.putExtra(RUN_COMMAND_SERVICE.EXTRA_COMMAND_PATH, "/data/data/com.termux/files/usr/bin/nmap");
intent.putExtra(RUN_COMMAND_SERVICE.EXTRA_ARGUMENTS, new String[]{"-oX","scan.xml","-sV", "--script", "vuln", "192.168.1.0/24"});
intent.putExtra(RUN_COMMAND_SERVICE.EXTRA_WORKDIR, "/storage/emulated/0/Termux");
intent.putExtra(RUN_COMMAND_SERVICE.EXTRA_BACKGROUND, true);
intent.putExtra(RUN_COMMAND_SERVICE.EXTRA_SESSION_ACTION, "0");
intent.putExtra(RUN_COMMAND_SERVICE.EXTRA_COMMAND_LABEL, "NMAP command");
intent.putExtra(RUN_COMMAND_SERVICE.EXTRA_COMMAND_DESCRIPTION, "Runs the NMAP command to show processes using the most resources.");

// Create the intent for the IntentService class that should be sent the result by TermuxService
Intent pluginResultsServiceIntent = new Intent(MainActivity.this, PluginResultsService.class);

// Generate a unique execution id for this execution command
int executionId = PluginResultsService.getNextExecutionId();

// Optional put an extra that uniquely identifies the command internally for your app.
// This can be an Intent extra as well with more extras instead of just an int.
pluginResultsServiceIntent.putExtra(PluginResultsService.EXTRA_EXECUTION_ID, executionId);

// Create the PendingIntent that will be used by TermuxService to send result of
// commands back to the IntentService
// Note that the requestCode (currently executionId) must be unique for each pending
// intent, even if extras are different, otherwise only the result of only the first
// execution will be returned since pending intent will be cancelled by android
// after the first result has been sent back via the pending intent and termux
// will not be able to send more.
PendingIntent pendingIntent = PendingIntent.getService(MainActivity.this, executionId, pluginResultsServiceIntent, PendingIntent.FLAG_ONE_SHOT);
intent.putExtra(RUN_COMMAND_SERVICE.EXTRA_PENDING_INTENT, pendingIntent);

try {
    // Send command intent for execution
    Log.d(LOG_TAG, "Sending execution command with id " + executionId);
    startService(intent);
} catch (Exception e) {
    Log.e(LOG_TAG, "Failed to start execution command with id " + executionId + ": " + e.getMessage());
}
}
}