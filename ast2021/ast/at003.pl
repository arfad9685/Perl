sub at003 {

print qq~

<ul id="jsddm">
<li><a href="/cgi-bin/sisasset.cgi"> <strong>LOGOUT</strong></a></li>

~;

if ($in{ubah} eq 'Change') {
  $q = $dba1->prepare("SELECT namausr,npassword  FROM X0000003 where namausr='$s3s[0]'");
  $q->execute();
  @row = $q->fetchrow_array();

 if ($in{oldpass} ne $row[1]) {
  $erruser="Wrong Old Password !";
 }
 if ($in{newpass} ne $in{konpass}) {
  $erruser="New Password Not Match !";
 }
 if (!$erruser) {
   $rowdo=$dba1->do("UPDATE x0000003 set npassword='$in{newpass}' where namausr='$s3s[0]'");
   if ($rowdo)
   {
    $erruser="Password Updated. Please Re-Login.";
   } else {
    $erruser="Action Canceled !";
   }
  }
}

print qq~
</ul>

<center><p>
    <table width="60%" border="0" cellspacing="0" cellpadding="1">
      <tr height=24 bgcolor=$menucolor>
        <td align=left><strong><span class="menu2">&nbsp;GANTI PASSWORD&nbsp;</span></strong></td>
        <td align=right><span class="menu2">&nbsp;User : $s3s[2]&nbsp;</td>
      </tr>
    </table>
    <hr width="100%" />
    <p><br>
    <form method="post" action=/cgi-bin/sisasset.cgi>
    <input type="hidden" name="pages" value="at003" />
    <input type="hidden" name=ss value=$in{ss}>

<table border="0" width="300" id="AutoNumber1" cellspacing="1" cellpadding="2" bordercolor="#FFFFFF">
<tr>
        <td width="50%" bgcolor=$colcolor align="left" class="hurufcol">&nbsp;Old Password</td>
        <td align=left><input type="password" name="oldpass" size="10"></td>
</tr>
<tr>
        <td width="50%" bgcolor=$colcolor align="left" class="hurufcol">&nbsp;New Password</td>
        <td align=left><input type="password" name="newpass" size="10"></td>
</tr>
<tr>
        <td width="129" bgcolor=$colcolor align="left" class="hurufcol">&nbsp;Confirm Password</td>
        <td width="80" align=left><input type="password" name="konpass" size="10"></td>
</tr>
</table>
    <br>
    <input type="submit" value="Change" name="ubah"><input type="reset" value="Reset" name="B2"></p>
    </form>
    <hr width="100" />~;
if ($erruser) {
 print qq~
    <table width="300" border="1" cellspacing="0" cellpadding="1">
      <tr height=24 bgcolor=white>
        <td align=center class="menu2"><strong>$erruser</strong></td>
      </tr>
    </table>~;
}
print qq~
</center>
~;
}
;
1
