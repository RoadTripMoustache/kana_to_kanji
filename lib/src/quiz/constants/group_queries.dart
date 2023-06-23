const _tableName = "groups";
const getGroupsQuery =
    "SELECT id, alphabet, name, localizedName FROM $_tableName WHERE alphabet=?";
