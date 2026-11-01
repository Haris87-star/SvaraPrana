package com.example.svaraprana

import android.content.Context
import android.media.RingtoneManager
import android.provider.AlarmClock
import android.content.Intent
import android.content.pm.PackageManager
import android.location.Location
import android.location.LocationManager
import android.net.Uri
import android.os.Bundle
import android.speech.tts.TextToSpeech
import androidx.core.app.ActivityCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.net.URLEncoder
import java.util.HashMap
import java.util.Locale

class MainActivity : FlutterActivity(), TextToSpeech.OnInitListener {
    private val CHANNEL = "com.svaraprana.app/native"
    private var textToSpeech: TextToSpeech? = null
    private var isTtsInitialized = false
    private var pendingSpeechText: String? = null
    private var pendingSpeechLang: String? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        try {
            textToSpeech = TextToSpeech(applicationContext, this)
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    override fun onInit(status: Int) {
        if (status == TextToSpeech.SUCCESS) {
            isTtsInitialized = true
            try {
                textToSpeech?.setSpeechRate(0.78f)
                textToSpeech?.setPitch(0.95f)
            } catch (e: Exception) {}

            val pending = pendingSpeechText
            val lang = pendingSpeechLang ?: "kn"
            if (pending != null && pending.isNotEmpty()) {
                speakTextInternal(pending, lang)
                pendingSpeechText = null
                pendingSpeechLang = null
            }
        }
    }

    private fun speakTextInternal(text: String, lang: String) {
        if (text.isEmpty()) return

        if (textToSpeech == null) {
            try {
                textToSpeech = TextToSpeech(applicationContext, this)
            } catch (e: Exception) {
                e.printStackTrace()
            }
            pendingSpeechText = text
            pendingSpeechLang = lang
            return
        }

        if (!isTtsInitialized) {
            pendingSpeechText = text
            pendingSpeechLang = lang
            return
        }

        try {
            val targetLocale = when (lang.lowercase()) {
                "kn", "kannada" -> Locale("kn", "IN")
                "hi", "hindi" -> Locale("hi", "IN")
                "ta", "tamil" -> Locale("ta", "IN")
                "te", "telugu" -> Locale("te", "IN")
                "mr", "marathi" -> Locale("mr", "IN")
                "bn", "bengali" -> Locale("bn", "IN")
                else -> Locale("en", "IN")
            }

            val langRes = textToSpeech?.setLanguage(targetLocale)
            if (langRes == TextToSpeech.LANG_MISSING_DATA || langRes == TextToSpeech.LANG_NOT_SUPPORTED) {
                val fallbackRes = textToSpeech?.setLanguage(Locale("hi", "IN"))
                if (fallbackRes == TextToSpeech.LANG_MISSING_DATA || fallbackRes == TextToSpeech.LANG_NOT_SUPPORTED) {
                    textToSpeech?.setLanguage(Locale.ENGLISH)
                }
            }

            textToSpeech?.setSpeechRate(0.78f)
            textToSpeech?.setPitch(0.95f)

            val params = Bundle()
            params.putFloat(TextToSpeech.Engine.KEY_PARAM_VOLUME, 1.0f)
            params.putInt(TextToSpeech.Engine.KEY_PARAM_STREAM, android.media.AudioManager.STREAM_MUSIC)
            textToSpeech?.speak(text, TextToSpeech.QUEUE_FLUSH, params, "svaraprana_utterance_" + System.currentTimeMillis())
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }


    override fun onPause() {
        super.onPause()
        try {
            textToSpeech?.stop()
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    override fun onStop() {
        super.onStop()
        try {
            textToSpeech?.stop()
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    override fun onDestroy() {
        try {
            textToSpeech?.stop()
            textToSpeech?.shutdown()
        } catch (e: Exception) {
            e.printStackTrace()
        }
        super.onDestroy()
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "speakText" -> {
                    val text = call.argument<String>("text") ?: ""
                    val lang = call.argument<String>("lang") ?: "kn"
                    speakTextInternal(text, lang)
                    result.success(true)
                }
                "stopTts" -> {
                    try {
                        textToSpeech?.stop()
                        result.success(true)
                    } catch (e: Exception) {
                        result.error("STOP_ERROR", e.message, null)
                    }
                }
                "dialCall" -> {
                    val phone = call.argument<String>("phone") ?: ""
                    val cleanPhone = phone.replace(Regex("[^0-9+]"), "")
                    if (cleanPhone.isNotEmpty()) {
                        try {
                            val dialUri = Uri.parse("tel:$cleanPhone")
                            val intent = Intent(Intent.ACTION_DIAL, dialUri).apply {
                                flags = Intent.FLAG_ACTIVITY_NEW_TASK
                            }
                            startActivity(intent)
                            result.success(true)
                        } catch (e: Exception) {
                            try {
                                val viewIntent = Intent(Intent.ACTION_VIEW, Uri.parse("tel:$cleanPhone")).apply {
                                    flags = Intent.FLAG_ACTIVITY_NEW_TASK
                                }
                                startActivity(viewIntent)
                                result.success(true)
                            } catch (e2: Exception) {
                                result.error("DIAL_ERROR", e2.message, null)
                            }
                        }
                    } else {
                        result.error("INVALID_PHONE", "Phone number is empty", null)
                    }
                }
                "getCurrentLocation" -> {
                    try {
                        val locationManager = getSystemService(Context.LOCATION_SERVICE) as LocationManager
                        var bestLocation: Location? = null

                        if (ActivityCompat.checkSelfPermission(this, android.Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED ||
                            ActivityCompat.checkSelfPermission(this, android.Manifest.permission.ACCESS_COARSE_LOCATION) == PackageManager.PERMISSION_GRANTED) {
                            
                            val providers = locationManager.getProviders(true)
                            for (provider in providers) {
                                val l = locationManager.getLastKnownLocation(provider) ?: continue
                                if (bestLocation == null || l.accuracy < bestLocation.accuracy) {
                                    bestLocation = l
                                }
                            }
                        }

                        val map = HashMap<String, Any>()
                        if (bestLocation != null) {
                            map["latitude"] = bestLocation.latitude
                            map["longitude"] = bestLocation.longitude
                            map["accuracy"] = bestLocation.accuracy.toDouble()
                            map["hasLocation"] = true
                            map["provider"] = bestLocation.provider ?: "gps"
                        } else {
                            map["hasLocation"] = false
                            map["latitude"] = 12.9716
                            map["longitude"] = 77.5946
                            map["accuracy"] = 15.0
                            map["provider"] = "approximate_city"
                        }
                        result.success(map)
                    } catch (e: Exception) {
                        result.error("LOCATION_ERROR", e.message, null)
                    }
                }
                "openWhatsApp" -> {
                    val phone = call.argument<String>("phone") ?: ""
                    val message = call.argument<String>("message") ?: ""
                    val cleanPhone = phone.replace(Regex("[^0-9]"), "")
                    try {
                        var launched = false
                        // 1. Direct WhatsApp package Intent with raw text (No plus signs, perfect line breaks and formatting)
                        val waIntent = Intent(Intent.ACTION_SEND).apply {
                            type = "text/plain"
                            setPackage("com.whatsapp")
                            putExtra(Intent.EXTRA_TEXT, message)
                            if (cleanPhone.isNotEmpty()) {
                                putExtra("jid", "$cleanPhone@s.whatsapp.net")
                            }
                            flags = Intent.FLAG_ACTIVITY_NEW_TASK
                        }
                        if (waIntent.resolveActivity(packageManager) != null) {
                            startActivity(waIntent)
                            launched = true
                        } else {
                            // 2. Direct URI intent with whatsapp:// scheme (Uri.encode uses %20 for spaces, not +)
                            val encoded = Uri.encode(message)
                            val waUri = if (cleanPhone.isNotEmpty()) {
                                "whatsapp://send?phone=$cleanPhone&text=$encoded"
                            } else {
                                "whatsapp://send?text=$encoded"
                            }
                            val uriIntent = Intent(Intent.ACTION_VIEW, Uri.parse(waUri)).apply {
                                flags = Intent.FLAG_ACTIVITY_NEW_TASK
                            }
                            if (uriIntent.resolveActivity(packageManager) != null) {
                                startActivity(uriIntent)
                                launched = true
                            }
                        }

                        // 3. Fallback: web API with Uri.encode
                        if (!launched) {
                            val encoded = Uri.encode(message)
                            val webUrl = if (cleanPhone.isNotEmpty()) {
                                "https://api.whatsapp.com/send?phone=$cleanPhone&text=$encoded"
                            } else {
                                "https://api.whatsapp.com/send?text=$encoded"
                            }
                            val webIntent = Intent(Intent.ACTION_VIEW, Uri.parse(webUrl)).apply {
                                flags = Intent.FLAG_ACTIVITY_NEW_TASK
                            }
                            startActivity(webIntent)
                        }
                        result.success(true)
                    } catch (e: Exception) {
                        result.error("WHATSAPP_ERROR", e.message, null)
                    }
                }
                "openMaps" -> {
                    val lat = call.argument<Double>("latitude") ?: 12.9716
                    val lng = call.argument<Double>("longitude") ?: 77.5946
                    val label = call.argument<String>("label") ?: "Senior Location"
                    try {
                        val uri = Uri.parse("geo:$lat,$lng?q=$lat,$lng(${Uri.encode(label)})")
                        val intent = Intent(Intent.ACTION_VIEW, uri).apply {
                            flags = Intent.FLAG_ACTIVITY_NEW_TASK
                        }
                        startActivity(intent)
                        result.success(true)
                    } catch (e: Exception) {
                        result.error("MAPS_ERROR", e.message, null)
                    }
                }
                "shareText" -> {
                    val text = call.argument<String>("text") ?: ""
                    val title = call.argument<String>("title") ?: "SvaraPrana Care Report"
                    try {
                        val sendIntent = Intent().apply {
                            action = Intent.ACTION_SEND
                            putExtra(Intent.EXTRA_TEXT, text)
                            type = "text/plain"
                        }
                        val shareIntent = Intent.createChooser(sendIntent, title).apply {
                            flags = Intent.FLAG_ACTIVITY_NEW_TASK
                        }
                        startActivity(shareIntent)
                        result.success(true)
                    } catch (e: Exception) {
                        result.error("SHARE_ERROR", e.message, null)
                    }
                }
                "setDeviceAlarm" -> {
                    val hour = call.argument<Int>("hour") ?: 8
                    val minute = call.argument<Int>("minute") ?: 30
                    val message = call.argument<String>("message") ?: "Call Parent - SvaraPrana Reminder"
                    val skipUi = call.argument<Boolean>("skipUi") ?: false
                    try {
                        val alarmIntent = Intent(AlarmClock.ACTION_SET_ALARM).apply {
                            putExtra(AlarmClock.EXTRA_HOUR, hour)
                            putExtra(AlarmClock.EXTRA_MINUTES, minute)
                            putExtra(AlarmClock.EXTRA_MESSAGE, message)
                            putExtra(AlarmClock.EXTRA_SKIP_UI, skipUi)
                            flags = Intent.FLAG_ACTIVITY_NEW_TASK
                        }
                        startActivity(alarmIntent)
                        result.success(true)
                    } catch (e: Exception) {
                        try {
                            val clockIntent = Intent(AlarmClock.ACTION_SHOW_ALARMS).apply {
                                flags = Intent.FLAG_ACTIVITY_NEW_TASK
                            }
                            startActivity(clockIntent)
                            result.success(true)
                        } catch (e2: Exception) {
                            result.error("ALARM_ERROR", e.message, null)
                        }
                    }
                }
                "playAlarmChime" -> {
                    try {
                        val alarmUri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM)
                            ?: RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION)
                        val ringtone = RingtoneManager.getRingtone(applicationContext, alarmUri)
                        ringtone?.play()
                        android.os.Handler(android.os.Looper.getMainLooper()).postDelayed({
                            try {
                                if (ringtone != null && ringtone.isPlaying) {
                                    ringtone.stop()
                                }
                            } catch (e: Exception) {}
                        }, 5000)
                        result.success(true)
                    } catch (e: Exception) {
                        result.error("CHIME_ERROR", e.message, null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }
}
