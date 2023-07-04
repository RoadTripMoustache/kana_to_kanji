const _tableName = "kana";
const getKanaByGroup =
    "SELECT id, alphabet, group_id, kana, romanji FROM $_tableName WHERE group_id=?";
const getKanaByGroups = "SELECT id, alphabet, group_id, kana, romanji FROM $_tableName WHERE group_id IN (?)";
