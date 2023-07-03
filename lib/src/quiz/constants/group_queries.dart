const _tableName = "groups";
const getGroupsQuery =
    "SELECT id, alphabet, name, localizedName, kanaType FROM $_tableName WHERE alphabet=?";
