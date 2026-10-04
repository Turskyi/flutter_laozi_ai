import SwiftUI
import WidgetKit

struct Verse {
    let chapter: Int
    let pageNumber: Int
    let textEn: String
    let textUk: String
    let textLv: String

    func text(for languageCode: String?) -> String {
        switch languageCode?.lowercased() {
        case "uk":
            return textUk
        case "lv":
            return textLv
        default:
            return textEn
        }
    }

    func chapterTitle(for languageCode: String?) -> String {
        switch languageCode?.lowercased() {
        case "uk":
            return "Розділ \(chapter)"
        case "lv":
            return "\(chapter). nodaļa"
        default:
            return "Chapter \(chapter)"
        }
    }

    func appTitle(for languageCode: String?) -> String {
        switch languageCode?.lowercased() {
        case "uk":
            return "Дао Де Цзін"
        case "lv":
            return "Dao De Czing"
        default:
            return "Tao Te Ching"
        }
    }
}

let verses: [Verse] = [
    Verse(
        chapter: 1,
        pageNumber: 4,
        textEn: "The Dao that can be spoken is not the constant Dao;\nthe name that can be named is not the constant name.",
        textUk: "Дао, про яке можна висловитись, не є постійне Дао;\nім'я, яке можна назвати, не є постійне ім'я.",
        textLv: "Dao, ko var izteikt vārdos, nav pastāvīgais Dao;\nvārds, ko var nosaukt, nav pastāvīgais vārds."
    ),
    Verse(
        chapter: 8,
        pageNumber: 5,
        textEn: "Highest goodness is like water.\nWater excels in benefiting all things without striving.",
        textUk: "Найвища доброчесність подібна до води.\nВода чудово сприяє всім речам без прагнення до суперництва.",
        textLv: "Visaugstākais labums ir kā ūdens.\nŪdens izceļas, dodot labumu visām lietām bez sacensības."
    ),
    Verse(
        chapter: 11,
        pageNumber: 6,
        textEn: "Thirty spokes share one hub;\nit is in its emptiness that the usefulness of the cart lies.",
        textUk: "Тридцять спиць ділять одну маточину;\nсаме в її порожнечі полягає користь колісниці.",
        textLv: "Trīsdesmit spieķi dalās ar vienu rumbu;\ntās tukšumā slēpjas ratu derīgums."
    ),
    Verse(
        chapter: 16,
        pageNumber: 7,
        textEn: "Attain utmost emptiness;\nmaintain steadfast tranquility.",
        textUk: "Досягни найбільшої порожнечі;\nзберігай непохитний спокій.",
        textLv: "Sasniedz vislielāko tukšumu;\nauzturi nelokāmu mieru."
    ),
    Verse(
        chapter: 22,
        pageNumber: 8,
        textEn: "Yield and remain whole;\nbend and be straightened;\nempty and be filled.",
        textUk: "Поступайся й залишайся цілим;\nзгинайся і випрямляйся;\nочищуйся і наповнюйся.",
        textLv: "Piekāpies un paliec vesels;\nliecies un iztaisnojies;\niztukšojies un piepildies."
    ),
    Verse(
        chapter: 23,
        pageNumber: 8,
        textEn: "To speak sparingly is natural.\nA whirlwind does not last all morning;\na sudden downpour does not last all day.",
        textUk: "Говорити ощадливо — природно.\nВихор не триває весь ранок;\nраптова злива не триває весь день.",
        textLv: "Runāt taupīgi ir dabiski.\nViesuļvētra neilgst visu rītu;\npēkšņa lietusgāze neilgst visu dienu."
    ),
    Verse(
        chapter: 26,
        pageNumber: 8,
        textEn: "The heavy is the root of the light;\nthe calm is the master of the hasty.",
        textUk: "Важке є коренем легкого;\nспокійне є володарем поспішного.",
        textLv: "Smagais ir vieglā sakne;\nklusais ir steidzīgā kungs."
    ),
    Verse(
        chapter: 33,
        pageNumber: 10,
        textEn: "Knowing others is intelligence;\nknowing yourself is true wisdom.\nMastering others is strength;\nmastering yourself is true power.",
        textUk: "Знання інших — це розум;\nзнання себе — це справжня мудрість.\nПеремога над іншими вимагає сили;\nперемога над собою — це справжня молитва.",
        textLv: "Zināt citus ir prāts;\nzināt sevi ir apgaismība.\nUzvarēt citus prasa spēku;\nuzvarēt sevi prasa varenību."
    ),
    Verse(
        chapter: 40,
        pageNumber: 11,
        textEn: "Return is the movement of the Dao.\nYielding is the way of the Dao.",
        textUk: "Повернення — це рух Дао.\nМ'якість — це дія Дао.",
        textLv: "Atgriešanās ir Dao kustība.\nVājums ir Dao izmantošana."
    ),
    Verse(
        chapter: 41,
        pageNumber: 11,
        textEn: "When a wise person hears of the Dao, they practice it diligently.",
        textUk: "Коли мудра людина чує про Дао, вона старанно слідує йому.",
        textLv: "Kad pārāks cilvēks dzird par Dao, viņš to cītīgi praktizē."
    ),
    Verse(
        chapter: 44,
        pageNumber: 12,
        textEn: "He who knows when he has enough is rich.\nHe who knows when to stop is free from danger.",
        textUk: "Хто знає достатність, той багатий.\nХто знає, коли зупинитися, той не зазнає небезпеки.",
        textLv: "Tas, kurš zina, kad ir pietiekami, ir bagāts.\nTas, kurš zina, kad apstāties, ir brīvs no briesmām."
    ),
    Verse(
        chapter: 56,
        pageNumber: 14,
        textEn: "Those who know do not speak;\nthose who speak do not know.",
        textUk: "Ті, хто знає, не говорять;\nті, хто говорять, не знають.",
        textLv: "Tie, kas zina, nerunā;\ntie, kas runā, nezina."
    ),
    Verse(
        chapter: 63,
        pageNumber: 15,
        textEn: "Act without acting;\nwork without working;\ntaste without tasting.",
        textUk: "Дій через недіяння;\nроби справи без метушні;\nвідчувай смак безсмакового.",
        textLv: "Rīkojies bez darbības;\nstrādā bez strādāšanas;\nizbaudi bez garšas."
    ),
    Verse(
        chapter: 64,
        pageNumber: 15,
        textEn: "A journey of a thousand miles begins with a single step.",
        textUk: "Подорож у тисячу лі починається з одного кроку.",
        textLv: "Tūkstoš jūdžu ceļojums sākas ar vienu soli."
    ),
    Verse(
        chapter: 67,
        pageNumber: 15,
        textEn: "I have three treasures:\ncompassion, frugality, and humility.",
        textUk: "Я маю три скарби:\nлюдяність, бережливість та лагідність.",
        textLv: "Man ir trīs dārgumi:\nlaipnība, taupība un pieticība."
    ),
    Verse(
        chapter: 81,
        pageNumber: 18,
        textEn: "True words are not beautiful;\nbeautiful words are not true.",
        textUk: "Правдиві слова не красиві;\nкрасиві слова не правдиві.",
        textLv: "Patiesi vārdi nav skaisti;\nskaisti vārdi nav patiesi."
    )
]

struct SimpleEntry: TimelineEntry {
    let date: Date
    let verse: Verse
    let languageCode: String?
}

struct Provider: TimelineProvider {
    let appGroupIdentifier = "group.dmytrowidget"

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), verse: verses[0], languageCode: "en")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = getCurrentEntry()
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        let now = Date()
        let calendar = Calendar.current
        let entry = getCurrentEntry()

        let nextUpdate = calendar.startOfDay(for: calendar.date(byAdding: .day, value: 1, to: now) ?? now.addingTimeInterval(86400))
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }

    private func getCurrentEntry() -> SimpleEntry {
        let defaults = UserDefaults(suiteName: appGroupIdentifier)
        let languageCode = defaults?.string(forKey: "selected_language") ?? "en"

        let calendar = Calendar.current
        let days = calendar.ordinality(of: .day, in: .era, for: Date()) ?? 1
        let index = (days - 1) % verses.count

        return SimpleEntry(date: Date(), verse: verses[index], languageCode: languageCode)
    }
}

struct LaoziAiWidgetsEntryView: View {
    var entry: SimpleEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(entry.verse.appTitle(for: entry.languageCode))
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                Spacer()
                Text(entry.verse.chapterTitle(for: entry.languageCode))
                    .font(.caption2)
                    .fontWeight(.bold)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.accentColor.opacity(0.15))
                    .cornerRadius(4)
            }

            Spacer(minLength: 2)

            Text("“\(entry.verse.text(for: entry.languageCode))”")
                .font(.footnote)
                .italic()
                .multilineTextAlignment(.leading)
                .lineLimit(5)
                .minimumScaleFactor(0.8)

            Spacer(minLength: 2)
        }
        .padding(12)
        .widgetURL(URL(string: "https://daoismonline.com/manuscript/\(entry.verse.pageNumber)"))
    }
}

struct LaoziAiWidgets: Widget {
    let kind: String = "LaoziAiWidgets"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, macOS 14.0, *) {
                LaoziAiWidgetsEntryView(entry: entry)
                    .containerBackground(.background, for: .widget)
            } else {
                LaoziAiWidgetsEntryView(entry: entry)
            }
        }
        .configurationDisplayName("Daily Verse")
        .description("Shows a daily verse from the Tao Te Ching.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
