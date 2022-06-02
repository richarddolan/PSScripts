param ($file, $me)
$session = new-csonlinesession -credential $me
import-pssession $session
$users = import-csv $file
foreach($user in $users){
Grant-CsTeamsUpgradePolicy -PolicyName Upgradetoteams -identity $user.userprincipalname}