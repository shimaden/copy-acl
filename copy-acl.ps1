# Example:
#   Copy the ACLs of all directories and files under E:\ from the Unknown User to the new user "alice".
#   E:\ 配下のすべてのディレクトリとファイルのACLを「不明なユーザー」から新しいユーザー "alice" にコピーする。

# 1. SIDを変数に格納
# 1. Store the SIDs in variables.
$UnknownSID = "S-1-5-21-603978908-3508826404-3620554346-1001"  # Unknown User's SID. 不明なユーザーのSID
$UserSID    = (Get-LocalUser -Name "alice").SID                # New user name.      新しいユーザーのユーザー名

# 2. 対象ディレクトリの下層を再帰的に取得
# 2. Recursively retrieve all subdirectories under the target directory.
# Specify the directory whose ACLs should recursively be copied from the Unknown User to the new user.
# このディレクトリ配下の不明なユーザーのACLが新しいユーザーにコピーされる
$Path = "E:\"  
$Items = Get-ChildItem $Path -Recurse -Force
# Include the parent directory as well. 親ディレクトリも対象に追加
$Items += Get-Item $Path

# 3. Edit the ACL for each folder and file.
# 3. 各フォルダ・ファイルに対してACLを編集
foreach ($Item in $Items) {
    $acl = Get-Acl $Item.FullName

    # Extract the access rights of the Unknown User
    # 不明なユーザーのアクセス権を抽出
    $unknownRules = $acl.Access | Where-Object { $_.IdentityReference.Value -eq $UnknownSID }

    foreach ($rule in $unknownRules) {
        # Create an access rule for the new user
        # 新しいユーザー用のアクセスルールを作成
        $newRule = New-Object System.Security.AccessControl.FileSystemAccessRule(
            $UserSID,
            $rule.FileSystemRights,
            $rule.InheritanceFlags,
            $rule.PropagationFlags,
            $rule.AccessControlType
        )
        # Add it to ACL. ACLに追加
        $acl.AddAccessRule($newRule)
    }

    # Apply ACL. ACLを適用
    Set-Acl -Path $Item.FullName -AclObject $acl
}
