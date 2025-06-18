package com.example.victim_voice

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.Intent
import android.app.Activity
import androidx.annotation.NonNull
import java.io.File
import android.provider.OpenableColumns
import android.net.Uri
import android.util.Log
import java.io.IOException

class MainActivity: FlutterActivity() {
    private val CHANNEL = "victim_voice/file_picker"
    private var pendingResult: MethodChannel.Result? = null
    private val TAG = "MainActivity"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "pickDocument" -> {
                    try {
                        pendingResult = result
                        pickDocument()
                    } catch (e: Exception) {
                        result.error("PICK_ERROR", "Error launching document picker: ${e.message}", null)
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun pickDocument() {
        try {
            val intent = Intent(Intent.ACTION_OPEN_DOCUMENT).apply {
                addCategory(Intent.CATEGORY_OPENABLE)
                type = "*/*"
                putExtra(Intent.EXTRA_MIME_TYPES, arrayOf(
                    "application/pdf",
                    "application/msword",
                    "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
                ))
                addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
            }
            startActivityForResult(intent, PICK_DOCUMENT_REQUEST_CODE)
        } catch (e: Exception) {
            Log.e(TAG, "Error launching document picker", e)
            pendingResult?.error("PICK_ERROR", "Error launching document picker: ${e.message}", null)
            pendingResult = null
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == PICK_DOCUMENT_REQUEST_CODE) {
            try {
                when {
                    resultCode != Activity.RESULT_OK -> {
                        pendingResult?.error("CANCELLED", "File picking was cancelled", null)
                    }
                    data?.data == null -> {
                        pendingResult?.error("NO_FILE", "No file was selected", null)
                    }
                    else -> {
                        val uri = data.data!!
                        try {
                            val filePath = getPathFromUri(uri)
                            pendingResult?.success(filePath)
                        } catch (e: Exception) {
                            Log.e(TAG, "Error processing selected file", e)
                            pendingResult?.error("PROCESS_ERROR", "Error processing selected file: ${e.message}", null)
                        }
                    }
                }
            } catch (e: Exception) {
                Log.e(TAG, "Error in activity result", e)
                pendingResult?.error("RESULT_ERROR", "Error handling picker result: ${e.message}", null)
            } finally {
                pendingResult = null
            }
        }
    }

    private fun getPathFromUri(uri: Uri): String {
        val cursor = contentResolver.query(uri, null, null, null, null)
        
        return cursor?.use { c ->
            if (c.moveToFirst()) {
                val displayName = c.getString(c.getColumnIndexOrThrow(OpenableColumns.DISPLAY_NAME))
                val inputStream = contentResolver.openInputStream(uri)
                
                inputStream?.use { input ->
                    val file = File(cacheDir, displayName)
                    try {
                        file.outputStream().use { output ->
                            input.copyTo(output)
                        }
                        file.absolutePath
                    } catch (e: IOException) {
                        Log.e(TAG, "Error copying file", e)
                        throw Exception("Could not copy file: ${e.message}")
                    }
                } ?: throw Exception("Could not open input stream")
            } else {
                throw Exception("Could not read file name")
            }
        } ?: throw Exception("Could not query file details")
    }

    companion object {
        private const val PICK_DOCUMENT_REQUEST_CODE = 2
    }
} 