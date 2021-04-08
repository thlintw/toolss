List<UnplugItemProfile> _genFakeItems(UnplugItemType type) {
  String idPrefix;
  switch (type) {
    case UnplugItemType.flower:
      idPrefix = 'f_';
      break;
    case UnplugItemType.vase:
      idPrefix = 'v_';
      break;
    case UnplugItemType.scene:
      idPrefix = 's_';
      break;
    default:
      idPrefix = 'id_';
      break;
  }
  return List.generate(15, (index) {
    return UnplugItemProfile(
      createAt: Timestamp.now(),
      canPurchase: true,
      canShow: true,
      cellNumber: 0,
      coin: 1,
      isDefault: index < 5 ? true : false,
      isOwned: index < 5 ? true : false,
      itemId: '$idPrefix${index.toString()}',
      itemType: type,
      name: 'item',
      permissions: [],
      photoFail: getPlaceholderImgUrl(),
      photoThumb: getPlaceholderImgUrl(),
      photos: [],
      updateAt: Timestamp.now(),
      version: 1,
    );
  });
}
