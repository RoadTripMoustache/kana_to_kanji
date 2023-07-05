const _tableName = "kana";
const getKanaByGroup =
    "SELECT id, alphabet, group_id, kana, romanji FROM $_tableName WHERE group_id=?";

getKanaByGroups([int listLength = 1]) =>
    "SELECT id, alphabet, group_id, kana, romanji FROM $_tableName WHERE group_id IN (${List.filled(listLength, "?").join(", ")})";
