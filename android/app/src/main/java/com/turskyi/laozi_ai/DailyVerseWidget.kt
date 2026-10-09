package com.turskyi.laozi_ai

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.os.Bundle
import android.view.View
import android.widget.RemoteViews
import androidx.core.net.toUri
import es.antonborri.home_widget.HomeWidgetPlugin
import java.util.Locale
import java.util.TimeZone
import kotlin.math.abs

class DailyVerseWidget : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    override fun onAppWidgetOptionsChanged(
        context: Context?,
        appWidgetManager: AppWidgetManager?,
        appWidgetId: Int,
        newOptions: Bundle?
    ) {
        super.onAppWidgetOptionsChanged(context, appWidgetManager, appWidgetId, newOptions)
        if (context != null && appWidgetManager != null) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        } else {
            // Context or AppWidgetManager was null
        }
    }

    companion object {
        private const val KEY_SELECTED_LANGUAGE = "selected_language"
        private const val MIN_WIDTH_FOR_DECORATION_DP = 180

        private data class VerseRes(
            val pageNumber: Int,
            val chapterTitleResId: Int,
            val textResId: Int
        )

        private val verses = listOf(
            VerseRes(4, R.string.verse_1_chapter, R.string.verse_1_text),
            VerseRes(5, R.string.verse_2_chapter, R.string.verse_2_text),
            VerseRes(6, R.string.verse_3_chapter, R.string.verse_3_text),
            VerseRes(7, R.string.verse_4_chapter, R.string.verse_4_text),
            VerseRes(8, R.string.verse_5_chapter, R.string.verse_5_text),
            VerseRes(8, R.string.verse_6_chapter, R.string.verse_6_text),
            VerseRes(8, R.string.verse_7_chapter, R.string.verse_7_text),
            VerseRes(10, R.string.verse_8_chapter, R.string.verse_8_text),
            VerseRes(11, R.string.verse_9_chapter, R.string.verse_9_text),
            VerseRes(11, R.string.verse_10_chapter, R.string.verse_10_text),
            VerseRes(12, R.string.verse_11_chapter, R.string.verse_11_text),
            VerseRes(14, R.string.verse_12_chapter, R.string.verse_12_text),
            VerseRes(15, R.string.verse_13_chapter, R.string.verse_13_text),
            VerseRes(15, R.string.verse_14_chapter, R.string.verse_14_text),
            VerseRes(15, R.string.verse_15_chapter, R.string.verse_15_text),
            VerseRes(18, R.string.verse_16_chapter, R.string.verse_16_text)
        )

        fun updateAppWidget(
            context: Context,
            appWidgetManager: AppWidgetManager,
            appWidgetId: Int
        ) {
            val widgetData: SharedPreferences = HomeWidgetPlugin.getData(context)
            val storedLanguage: String? = widgetData.getString(KEY_SELECTED_LANGUAGE, "en")
            val languageCode: String = if (storedLanguage != null) {
                storedLanguage
            } else {
                "en"
            }

            val localizedContext = getLocalizedContext(context, languageCode)

            val daysSinceEpoch = (System.currentTimeMillis() + TimeZone.getDefault().getOffset(System.currentTimeMillis())) / (24 * 60 * 60 * 1000L)
            val index = (abs(daysSinceEpoch) % verses.size).toInt()
            val verse = verses[index]

            val options = appWidgetManager.getAppWidgetOptions(appWidgetId)
            val minWidth = options?.getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_WIDTH, 0) ?: 0

            val decorativeVisibility = if (minWidth == 0 || minWidth >= MIN_WIDTH_FOR_DECORATION_DP) {
                View.VISIBLE
            } else {
                View.GONE
            }

            val views = RemoteViews(context.packageName, R.layout.daily_verse_widget).apply {
                setTextViewText(R.id.text_app_title, localizedContext.getString(R.string.app_title_short))
                setTextViewText(R.id.text_chapter_title, localizedContext.getString(verse.chapterTitleResId))
                setTextViewText(R.id.text_verse, "“" + localizedContext.getString(verse.textResId) + "”")
                setViewVisibility(R.id.text_decorative_column, decorativeVisibility)

                val intent = Intent(context, MainActivity::class.java).apply {
                    action = "es.antonborri.home_widget.action.LAUNCH"
                    data =
                        "https://daoismonline.com/manuscript/${verse.pageNumber}".toUri()
                }
                val pendingIntent = PendingIntent.getActivity(
                    context,
                    0,
                    intent,
                    PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                )
                setOnClickPendingIntent(R.id.widget_container, pendingIntent)
            }

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }

        private fun getLocalizedContext(context: Context, languageCode: String): Context {
            val locale = Locale.forLanguageTag(languageCode)
            Locale.setDefault(locale)
            val config = android.content.res.Configuration(context.resources.configuration)
            config.setLocale(locale)
            return context.createConfigurationContext(config)
        }
    }
}
