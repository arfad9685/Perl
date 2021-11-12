sub hk001e {

genfuncast::view_header($in{ss}, $s3s[2], 'Edit Hak Akses User');
genfuncast::validasi_akses($s3s[11], $in{ss}, 'S');

if ($in{submit})
{  for ($i=1; $i<=$in{baris}; $i++)
   {
      if ($in{"rec$i"})
      {    if (!$in{"hak$i"}) { $exin=""; }
           else  { $exin='W'; }
           if (!$in{"hak$i"})
           {
             $postall = $dba1->do("DELETE FROM X0000004  WHERE recid='".$in{"rec$i"}."' ");
           }
           else
           { # print qq~UPDATE X0000004 SET hwrite='".$in{"hak$i"}."', EX_IN='$exin', OPRUPDATE='$s3s[0]' WHERE recid='".$in{"rec$i"}."'<br/>~;
             $postall = $dba1->do("UPDATE X0000004 SET hwrite='".$in{"hak$i"}."', EX_IN='$exin', OPRUPDATE='$s3s[0]' WHERE recid='".$in{"rec$i"}."' ");
           }
      }
      elsif ($in{"hak$i"})
      {    $postall = $dba1->do("INSERT INTO X0000004 (NAMAUSR, EXEID, XID, HWRITE, EX_IN, OPRCREATE)
           values ('$in{usr}', '".$in{"exe$i"}."', '".$in{"xid$i"}."', '".$in{"hak$i"}."', 'W', '$s3s[0]') ");
#           print "INSERT INTO X0000004 (NAMAUSR, EXEID, XID, HWRITE, EX_IN, OPRCREATE)
#           values ('$in{usr}', '".$in{"exe$i"}."', '".$in{"xid$i"}."', '".$in{"hak$i"}."', 'W', '$s3s[0]')<br/>";
      }

   }
   #$dba1->commit;
   $warning="<div class=warning_ok>&nbsp; Sukses Update Hak Akses User '$in{usr}'</div><br/>";
}

print qq~
     <table width=1000 border="0" cellspacing="0" cellpadding="0">
     <tr>
     <td align=left width=150>
     <form method=post action="/cgi-bin/sisasset.cgi" >
      <input type="submit" name="back" value="Back" class="huruf1"/>
      <input name="pages" type="hidden" value=hk001>
      <input name="usr" type="hidden" value=$in{usr}>
      <input name="dep" type="hidden" value=$in{dep}>
      <input name="subdiv" type="hidden" value=$in{subdiv}>
      <input name="div" type="hidden" value=$in{div}>
      <input name="ss" type="hidden" value="$in{ss}"> </form>
     </td>
     <td align=center> <h2 class="hurufcol"> EDIT HAK AKSES <br/>USER : $in{usr}</h2> </td>
     <td align=left width=150>
     &nbsp;
     </td>
     </tr>
     </table>  ~;

print qq ~
$warning
   <FORM ACTION="/cgi-bin/sisasset.cgi" METHOD="post" name='ha'>
  <input type=hidden name=ss value="$in{ss}">
  <input type=hidden name=pages value=hk001e>
  <input name="pageid" type="hidden" value='$tmp_tgl[3]'>
 <input type=hidden name='usr' value='$in{usr}'>

  <table width='600px' border='0' cellspacing='1' cellpadding='2'>
  <tr bgcolor="$dark">
   <td align='center' class="hurufcol" width=50> No. </td>
   <td align='center' class="hurufcol" width=80> Menu</td>
   <td align='center' class="hurufcol" width=80>Hak Akses</td>~;

$q = $dba1->prepare("select  xid, namamenu, namaexe, namaprog, b.namausr, b.hwrite, recid from
(select  xid, namamenu, namaexe, namaprog from X0000002 k, X0000001 l
where k.xid=l.recid ) a
 left join
 (select m.namausr, hwrite, exeid, recid from X0000004 m, X0000003 n where m.namausr=n.namausr)
 b on a.namaexe=b.exeid and b.namausr='$in{usr}'
  order by xid, namaprog, namausr");
$q->execute();
$no=1;
$tmpxid="";
@hakakses = ('','Y','S');
@hakakses_text = ('No View','View','Supervisor');
while (@row = $q->fetchrow_array())
{ if ($row[5]) { $hak=$row[5]; }
  else { $hak="&nbsp;"; }

  if ($tmpxid ne  $row[0])
  { print qq~</tr><tr bgcolor=$colcolor height=20> <td class="hurufcol" colspan=3> $row[1]</td>~; }

   if ($no%2==1) { $bg=$colcolor2; }
    else { $bg=$colcolor3; }
    print qq~
    </tr>
    <tr bgcolor=$bg height=20>
     <td align='center' class="hurufcol" valign="top">$no </td>
     <td class="hurufcol" valign="top">$row[3]</td>
     <td align='center' class="hurufcol" valign="top">
       <input type=hidden name=rec$no value=$row[6]>
       <input type=hidden name=exe$no value=$row[2]>
       <input type=hidden name=xid$no value=$row[0]>~;
     for ($i=0; $i<@hakakses; $i++)
     { $checked="";
       if ($row[5] eq $hakakses[$i]) { $checked="checked"; }
       print qq~<input type=radio name='hak$no' value='$hakakses[$i]' $checked> $hakakses_text[$i] &nbsp;&nbsp;&nbsp;&nbsp; ~;
     }
    print qq~
     </td>
    ~;
    $no++;

  $tmpxid=$row[0];
}
$no--;

print qq ~
   </tr>
</table>
<input type=hidden name=baris value=$no>
<input type=submit name=submit value=Simpan>
</form>
~;

print qq ~
    <hr width="100" />
</center>
~;
}

;
1

