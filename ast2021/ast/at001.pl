sub at001 {

print qq~
<center>
            <table width="300" border="0" cellspacing="1" cellpadding="0">
            <tr>
              <td height="25" colspan="3" align="center" valign="middle" bgcolor=#ffffff class="menu1"><p>&nbsp;</p>
              <p><img src="/images/logo_sisasset.jpg" /> </p>
              </td>
            </tr>~;

#if (($in{vpc} ne '1.05') || (!$in{ipc}))
#{
#  print qq~
#           <tr>
#              <td>&nbsp;</td>
#              <td align=center colspan="2">&nbsp;<font face=verdana color=red size=2><b>Anda sudah Logout.<br>
#              Untuk Login kembali harap keluar dan masuk kembali dari SISASSET.</b></font></td>
#           </tr>~;
#} else
{

  $subjdl = "";
  if ($jaringan!=1) { $subjdl = "<font color=red> LOCAL</font>"; }

  print qq~

            <tr>
              <td height="25" colspan="3" align="center" valign="middle" bgcolor=$dark class="menu1"><strong>LOGIN  $subjdl</strong></td>
              </tr>
            <form method=POST action=/cgi-bin/sisasset.cgi>
            <tr>
              <td width="2%">&nbsp;</td>
              <td align=left width="36%" bgcolor=$colcolor class="hurufcol">&nbsp;<span class="hurufcol">Login :                </span></td>
              <td align=left width="62%"><input name="nama" type="text" class="huruf1" size="10"/></td>
            </tr>
            <tr>
              <td>&nbsp;</td>
              <td align=left bgcolor=$colcolor class="hurufcol">&nbsp;Password :                </td>
              <td align=left><input name="npass" type="password" class="huruf1" size="10"/></td>
            </tr>
            <tr>
              <td>&nbsp;<input name="ipc" type="hidden" value="$in{ipc}"/>
              <input name="npc" type="hidden" value="$in{npc}"/>
              <input name="mpc" type="hidden" value="$in{mpc}"/>
              <input name="vpc" type="hidden" value="$in{vpc}"/>
              </td>
              <td colspan="2"><input name="Login" type="submit" class="huruf2" value="Login" />
              <input name="pages" type="hidden" value="at002" />
              </td>
            </tr>
            </form>
            <tr>
              <td>&nbsp;</td>
              <td align=center colspan="2">&nbsp;<font face=verdana color=red size=2><b>$psnmuka</b></font></td>
            </tr>~;
}
print qq~
          </table>
</center>
~;
}
;
1
