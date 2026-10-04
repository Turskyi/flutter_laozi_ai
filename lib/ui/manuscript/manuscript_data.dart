import 'package:flutter_translate/flutter_translate.dart';

const int kMinManuscriptPage = 1;
const int kMaxManuscriptPage = 18;

class ManuscriptPieceData {
  const ManuscriptPieceData({required this.imageSrc, required this.captionKey});

  final String imageSrc;
  final String captionKey;

  String caption() => translate(captionKey);
}

class ManuscriptPageData {
  const ManuscriptPageData({
    required this.pageNumber,
    required this.titleKey,
    required this.shortTitleKey,
    required this.imageSrc,
    required this.captionKey,
    required this.contentKey,
    this.pieces = const <ManuscriptPieceData>[],
    this.isLastPage = false,
  });

  final int pageNumber;
  final String titleKey;
  final String shortTitleKey;
  final String imageSrc;
  final String captionKey;
  final String contentKey;
  final List<ManuscriptPieceData> pieces;
  final bool isLastPage;

  String get title => translate(titleKey);
  String get shortTitle => translate(shortTitleKey);
  String get caption => translate(captionKey);
  String get content => translate(contentKey);

  List<ManuscriptPieceData> get resolvedPieces {
    if (pieces.isNotEmpty) {
      return pieces;
    }
    return <ManuscriptPieceData>[
      ManuscriptPieceData(imageSrc: imageSrc, captionKey: captionKey),
    ];
  }

  String? get note {
    if (pageNumber == 1 ||
        pageNumber == 2 ||
        pageNumber == 3 ||
        pageNumber == 7) {
      return translate('manuscript.notes.page_$pageNumber');
    }
    return null;
  }
}

const List<ManuscriptPageData> manuscriptPagesData = <ManuscriptPageData>[
  ManuscriptPageData(
    pageNumber: 1,
    titleKey: 'manuscript.pages.page_1.title',
    shortTitleKey: 'manuscript.pages.page_1.short_title',
    imageSrc: 'assets/manuscripts/pelliot-2584/page-1.jpg',
    captionKey: 'manuscript.captions.c2584',
    contentKey: 'manuscript.pages.page_1.content',
  ),
  ManuscriptPageData(
    pageNumber: 2,
    titleKey: 'manuscript.pages.page_2.title',
    shortTitleKey: 'manuscript.pages.page_2.short_title',
    imageSrc: 'assets/manuscripts/pelliot-2584/page-2.jpg',
    captionKey: 'manuscript.captions.c2584',
    contentKey: 'manuscript.pages.page_2.content',
  ),
  ManuscriptPageData(
    pageNumber: 3,
    titleKey: 'manuscript.pages.page_3.title',
    shortTitleKey: 'manuscript.pages.page_3.short_title',
    imageSrc: 'assets/manuscripts/pelliot-2584/page-3.jpg',
    captionKey: 'manuscript.captions.c2584',
    contentKey: 'manuscript.pages.page_3.content',
  ),
  ManuscriptPageData(
    pageNumber: 4,
    titleKey: 'manuscript.pages.page_4.title',
    shortTitleKey: 'manuscript.pages.page_4.short_title',
    imageSrc: 'assets/manuscripts/pelliot-2584/page-4.jpg',
    captionKey: 'manuscript.captions.c2584',
    contentKey: 'manuscript.pages.page_4.content',
  ),
  ManuscriptPageData(
    pageNumber: 5,
    titleKey: 'manuscript.pages.page_5.title',
    shortTitleKey: 'manuscript.pages.page_5.short_title',
    imageSrc: 'assets/manuscripts/pelliot-2584/page-5.jpg',
    captionKey: 'manuscript.captions.c2584',
    contentKey: 'manuscript.pages.page_5.content',
  ),
  ManuscriptPageData(
    pageNumber: 6,
    titleKey: 'manuscript.pages.page_6.title',
    shortTitleKey: 'manuscript.pages.page_6.short_title',
    imageSrc: 'assets/manuscripts/pelliot-2584/page-6.jpg',
    captionKey: 'manuscript.captions.c2584',
    contentKey: 'manuscript.pages.page_6.content',
  ),
  ManuscriptPageData(
    pageNumber: 7,
    titleKey: 'manuscript.pages.page_7.title',
    shortTitleKey: 'manuscript.pages.page_7.short_title',
    imageSrc: 'assets/manuscripts/pelliot-2584/page-7.jpg',
    captionKey: 'manuscript.captions.c2584',
    contentKey: 'manuscript.pages.page_7.content',
    pieces: <ManuscriptPieceData>[
      ManuscriptPieceData(
        imageSrc: 'assets/manuscripts/pelliot-2584/page-7.jpg',
        captionKey: 'manuscript.captions.c2584',
      ),
      ManuscriptPieceData(
        imageSrc: 'assets/manuscripts/pelliot-2255/page-7.jpg',
        captionKey: 'manuscript.captions.c2255',
      ),
    ],
  ),
  ManuscriptPageData(
    pageNumber: 8,
    titleKey: 'manuscript.pages.page_8.title',
    shortTitleKey: 'manuscript.pages.page_8.short_title',
    imageSrc: 'assets/manuscripts/pelliot-2584/page-8.jpg',
    captionKey: 'manuscript.captions.c2584',
    contentKey: 'manuscript.pages.page_8.content',
    pieces: <ManuscriptPieceData>[
      ManuscriptPieceData(
        imageSrc: 'assets/manuscripts/pelliot-2584/page-8.jpg',
        captionKey: 'manuscript.captions.c2584',
      ),
      ManuscriptPieceData(
        imageSrc: 'assets/manuscripts/pelliot-2255/page-8.jpg',
        captionKey: 'manuscript.captions.c2255',
      ),
    ],
  ),
  ManuscriptPageData(
    pageNumber: 9,
    titleKey: 'manuscript.pages.page_9.title',
    shortTitleKey: 'manuscript.pages.page_9.short_title',
    imageSrc: 'assets/manuscripts/pelliot-2584/page-9.jpg',
    captionKey: 'manuscript.captions.c2584',
    contentKey: 'manuscript.pages.page_9.content',
    pieces: <ManuscriptPieceData>[
      ManuscriptPieceData(
        imageSrc: 'assets/manuscripts/pelliot-2584/page-9.jpg',
        captionKey: 'manuscript.captions.c2584',
      ),
      ManuscriptPieceData(
        imageSrc: 'assets/manuscripts/pelliot-2255/page-9.jpg',
        captionKey: 'manuscript.captions.c2255',
      ),
    ],
  ),
  ManuscriptPageData(
    pageNumber: 10,
    titleKey: 'manuscript.pages.page_10.title',
    shortTitleKey: 'manuscript.pages.page_10.short_title',
    imageSrc: 'assets/manuscripts/pelliot-2584/page-10.jpg',
    captionKey: 'manuscript.captions.c2584',
    contentKey: 'manuscript.pages.page_10.content',
    pieces: <ManuscriptPieceData>[
      ManuscriptPieceData(
        imageSrc: 'assets/manuscripts/pelliot-2584/page-10.jpg',
        captionKey: 'manuscript.captions.c2584',
      ),
      ManuscriptPieceData(
        imageSrc: 'assets/manuscripts/pelliot-2255/page-10.jpg',
        captionKey: 'manuscript.captions.c2255',
      ),
    ],
  ),
  ManuscriptPageData(
    pageNumber: 11,
    titleKey: 'manuscript.pages.page_11.title',
    shortTitleKey: 'manuscript.pages.page_11.short_title',
    imageSrc: 'assets/manuscripts/pelliot-2255/page-11.jpg',
    captionKey: 'manuscript.captions.c2255',
    contentKey: 'manuscript.pages.page_11.content',
  ),
  ManuscriptPageData(
    pageNumber: 12,
    titleKey: 'manuscript.pages.page_12.title',
    shortTitleKey: 'manuscript.pages.page_12.short_title',
    imageSrc: 'assets/manuscripts/pelliot-2255/page-12.jpg',
    captionKey: 'manuscript.captions.c2255',
    contentKey: 'manuscript.pages.page_12.content',
  ),
  ManuscriptPageData(
    pageNumber: 13,
    titleKey: 'manuscript.pages.page_13.title',
    shortTitleKey: 'manuscript.pages.page_13.short_title',
    imageSrc: 'assets/manuscripts/pelliot-2255/page-13.jpg',
    captionKey: 'manuscript.captions.c2255',
    contentKey: 'manuscript.pages.page_13.content',
  ),
  ManuscriptPageData(
    pageNumber: 14,
    titleKey: 'manuscript.pages.page_14.title',
    shortTitleKey: 'manuscript.pages.page_14.short_title',
    imageSrc: 'assets/manuscripts/pelliot-2255/page-14.jpg',
    captionKey: 'manuscript.captions.c2255',
    contentKey: 'manuscript.pages.page_14.content',
  ),
  ManuscriptPageData(
    pageNumber: 15,
    titleKey: 'manuscript.pages.page_15.title',
    shortTitleKey: 'manuscript.pages.page_15.short_title',
    imageSrc: 'assets/manuscripts/pelliot-2255/page-15.jpg',
    captionKey: 'manuscript.captions.c2255',
    contentKey: 'manuscript.pages.page_15.content',
  ),
  ManuscriptPageData(
    pageNumber: 16,
    titleKey: 'manuscript.pages.page_16.title',
    shortTitleKey: 'manuscript.pages.page_16.short_title',
    imageSrc: 'assets/manuscripts/pelliot-2255/page-16.jpg',
    captionKey: 'manuscript.captions.c2255',
    contentKey: 'manuscript.pages.page_16.content',
  ),
  ManuscriptPageData(
    pageNumber: 17,
    titleKey: 'manuscript.pages.page_17.title',
    shortTitleKey: 'manuscript.pages.page_17.short_title',
    imageSrc: 'assets/manuscripts/pelliot-2255/page-17.jpg',
    captionKey: 'manuscript.captions.c2255',
    contentKey: 'manuscript.pages.page_17.content',
  ),
  ManuscriptPageData(
    pageNumber: 18,
    titleKey: 'manuscript.pages.page_18.title',
    shortTitleKey: 'manuscript.pages.page_18.short_title',
    imageSrc: 'assets/manuscripts/pelliot-2255/page-18.jpg',
    captionKey: 'manuscript.captions.c2255',
    contentKey: 'manuscript.pages.page_18.content',
    isLastPage: true,
  ),
];

ManuscriptPageData getManuscriptPageData(int pageNumber) {
  return manuscriptPagesData.firstWhere(
    (ManuscriptPageData p) => p.pageNumber == pageNumber,
    orElse: () => manuscriptPagesData.first,
  );
}
