import "package:kana_to_kanji/src/core/constants/languages.dart";
import "package:kana_to_kanji/src/core/models/user/user.dart";
import "package:kana_to_kanji/src/core/models/user/user_preferences.dart";

/// A dummy SVG string for testing avatar
const dummySvg =
    '''<svg width="264px" height="280px" viewBox="0 0 264 280" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"> <desc>AvatarMaker on pub.dev</desc> <defs> <circle id="path-1" cx="120" cy="120" r="120"></circle> <path d="M12,160 C12,226.27417 65.72583,280 132,280 C198.27417,280 252,226.27417 252,160 L264,160 L264,-1.42108547e-14 L-3.19744231e-14,-1.42108547e-14 L-3.19744231e-14,160 L12,160 Z" id="path-3"></path> <path d="M124,144.610951 L124,163 L128,163 L128,163 C167.764502,163 200,195.235498 200,235 L200,244 L0,244 L0,235 C-4.86974701e-15,195.235498 32.235498,163 72,163 L72,163 L76,163 L76,144.610951 C58.7626345,136.422372 46.3722246,119.687011 44.3051388,99.8812385 C38.4803105,99.0577866 34,94.0521096 34,88 L34,74 C34,68.0540074 38.3245733,63.1180731 44,62.1659169 L44,56 L44,56 C44,25.072054 69.072054,5.68137151e-15 100,0 L100,0 L100,0 C130.927946,-5.68137151e-15 156,25.072054 156,56 L156,62.1659169 C161.675427,63.1180731 166,68.0540074 166,74 L166,88 C166,94.0521096 161.51969,99.0577866 155.694861,99.8812385 C153.627775,119.687011 141.237365,136.422372 124,144.610951 Z" id="path-5"></path> </defs> <g id="AvatarMaker" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd"> <g transform="translate(-825.000000, -1100.000000)" id="avatar_maker/Circle"> <g transform="translate(825.000000, 1100.000000)"> <g id="Mask"></g> <g id="AvatarMaker" stroke-width="1" fill-rule="evenodd"> <g id="Body" transform="translate(32.000000, 36.000000)"> <mask id="mask-6" fill="white"> <use xlink:href="#path-5"></use> </mask> <use fill="#D0C6AC" xlink:href="#path-5"></use> <g id="Skin/Brown" mask="url(#mask-6)" fill="#D08B5B"> <g transform="translate(0.000000, 0.000000)" id="Color"> <rect x="0" y="0" width="264" height="280" /> </g> </g> <path d="M156,79 L156,102 C156,132.927946 130.927946,158 100,158 C69.072054,158 44,132.927946 44,102 L44,79 L44,94 C44,124.927946 69.072054,150 100,150 C130.927946,150 156,124.927946 156,94 L156,79 Z" id="Neck-Shadow" opacity="0.100000001" fill="#000000" mask="url(#mask-6)"></path> </g> <g id=" OutfitTypes/Hoodie" transform="translate(0.000000, 170.000000)"> <defs> <path d="M108,13.0708856 C90.0813006,15.075938 76.2798424,20.5518341 76.004203,34.6449676 C50.1464329,45.5680933 32,71.1646257 32,100.999485 L32,100.999485 L32,110 L232,110 L232,100.999485 C232,71.1646257 213.853567,45.5680933 187.995797,34.6449832 C187.720158,20.5518341 173.918699,15.075938 156,13.0708856 L156,32 L156,32 C156,45.254834 145.254834,56 132,56 L132,56 C118.745166,56 108,45.254834 108,32 L108,13.0708856 Z" id="react-path-35937"></path> </defs> <mask id="react-mask-35938" fill="white"> <use xlink:href="#react-path-35937"></use> </mask> <use id="Hoodie" fill="#B7C1DB" fill-rule="evenodd" xlink:href="#react-path-35937"></use> <g id="Color/Outfit" mask="url(#react-mask-35938)" fill-rule="evenodd" fill="#B1E2FF"> <rect id="🖍Color" x="0" y="0" width="264" height="110"></rect> </g> <path d="M102,61.7390531 L102,110 L95,110 L95,58.1502625 C97.2037542,59.4600576 99.5467694,60.6607878 102,61.7390531 Z M169,58.1502625 L169,98.5 C169,100.432997 167.432997,102 165.5,102 C163.567003,102 162,100.432997 162,98.5 L162,61.7390531 C164.453231,60.6607878 166.796246,59.4600576 169,58.1502625 Z" id="Straps" fill="#F4F4F4" fill-rule="evenodd" mask="url(#react-mask-35938)"></path> <path d="M90.9601329,12.7243537 C75.9093095,15.5711782 65.5,21.2428847 65.5,32.3076923 C65.5,52.0200095 98.5376807,68 132,68 C165.462319,68 198.5,52.0200095 198.5,32.3076923 C198.5,21.2428847 188.09069,15.5711782 173.039867,12.7243537 C182.124921,16.0744598 188,21.7060546 188,31.0769231 C188,51.4689754 160.178795,68 132,68 C103.821205,68 76,51.4689754 76,31.0769231 C76,21.7060546 81.8750795,16.0744598 90.9601329,12.7243537 Z" id="Shadow" fill-opacity="0.16" fill="#000000" fill-rule="evenodd" mask="url(#react-mask-35938)"></path> </g> <g id="Face" transform="translate(76.000000, 82.000000)" fill="#000000"> <g id="Mouth/Default" transform="translate(2.000000, 52.000000)" fill-opacity="0.699999988"> <path d="M40,15 C40,22.7319865 46.2680135,29 54,29 L54,29 C61.7319865,29 68,22.7319865 68,15" id="Mouth"></path> </g> <g id="Nose/Default" transform="translate(28.000000, 40.000000)" opacity="0.16"> <path d="M16,8 C16,12.418278 21.372583,16 28,16 L28,16 C34.627417,16 40,12.418278 40,8" id="Nose"></path> </g> <g id="Eyes/Default" transform="translate(0.000000, 8.000000)" fillOpacity="0.599999964"> <circle id="Eye" cx="30" cy="22" r="6" /> <circle id="Eye" cx="82" cy="22" r="6" /> </g> <g id="Eyebrows/Default" fillOpacity="0.599999964"> <g id="I-Browse" transform="translate(12.000000, 6.000000)"> <path d="M3.63024536,11.1585767 C7.54515501,5.64986673 18.2779197,2.56083721 27.5230268,4.83118046 C28.5957248,5.0946055 29.6788665,4.43856013 29.9422916,3.36586212 C30.2057166,2.2931641 29.5496712,1.21002236 28.4769732,0.94659732 C17.7403633,-1.69001789 5.31209962,1.88699832 0.369754639,8.84142326 C-0.270109626,9.74178291 -0.0589363917,10.9903811 0.84142326,11.6302454 C1.74178291,12.2701096 2.9903811,12.0589364 3.63024536,11.1585767 Z" id="Eyebrow" fillRule="nonzero" /> <path d="M61.6302454,11.1585767 C65.545155,5.64986673 76.2779197,2.56083721 85.5230268,4.83118046 C86.5957248,5.0946055 87.6788665,4.43856013 87.9422916,3.36586212 C88.2057166,2.2931641 87.5496712,1.21002236 86.4769732,0.94659732 C75.7403633,-1.69001789 63.3120996,1.88699832 58.3697546,8.84142326 C57.7298904,9.74178291 57.9410636,10.9903811 58.8414233,11.6302454 C59.7417829,12.2701096 60.9903811,12.0589364 61.6302454,11.1585767 Z" id="Eyebrow" fillRule="nonzero" transform="translate(73.000154, 6.039198) scale(-1, 1) translate(-73.000154, -6.039198) " /> </g> </g> </g> </g> </g> </g> </g></svg>''';

/// A dummy user for testing
final dummyUser = User(
  externalId: "test-external-id",
  createdAt: "2023-01-01T00:00:00.000Z",
  lastUpdate: "2023-01-01T00:00:00.000Z",
  displayName: "Test User",
  preferences: const UserPreferences(language: Languages.EN),
  uuid: "test-uuid",
  avatar: dummySvg,
  streakStartDate: DateTime(2023),
  streakLastUpdate: DateTime(2023, 1, 10),
);

/// A dummy user without avatar for testing
final dummyUserWithoutAvatar = User(
  externalId: "test-external-id",
  createdAt: "2023-01-01T00:00:00.000Z",
  lastUpdate: "2023-01-01T00:00:00.000Z",
  displayName: "Test User",
  preferences: const UserPreferences(language: Languages.EN),
  uuid: "test-uuid",
  streakStartDate: DateTime(2023),
  streakLastUpdate: DateTime(2023, 1, 10),
);

/// A dummy user with empty display name for testing
final dummyUserWithEmptyName = User(
  externalId: "test-external-id",
  createdAt: "2023-01-01T00:00:00.000Z",
  lastUpdate: "2023-01-01T00:00:00.000Z",
  displayName: "",
  preferences: const UserPreferences(language: Languages.EN),
  uuid: "test-uuid",
  avatar: dummySvg,
  streakStartDate: DateTime(2023),
  streakLastUpdate: DateTime(2023, 1, 10),
);
