sub hk001 {

genfuncast::view_header($in{ss}, $s3s[2], 'Hak Akses User');
genfuncast::validasi_akses($s3s[11], $in{ss});

print qq~
<script type='text/javascript' src='/jquery.min.js'></script>
<script type='text/javascript' src="/jquery.chained.js"></script>
     <table width=1000 border="0" cellspacing="0" cellpadding="0">
     <tr>
     <td align=left width=150>
     &nbsp;
     </td>
     <td align=center> <h2 class="hurufcol"> HAK AKSES USER</h2> </td>
     <td align=left width=150>
      <form method=post action="/cgi-bin/sisasset.cgi" >
      <input name="btn" type="submit" value="Hapus Akses User" class=huruf1>
      <input name="pages" type="hidden" value=hk001d>
      <input name="ss" type="hidden" value="$in{ss}">  </form></td>
     </tr>
     </table>
 ~;

if ($s3s[11] eq 'S')
{
print qq ~
<script type="text/javascript">
function validasi(u)
{
      with(document.ha)
          { usr.value=u;
           submit();
          }

}
</script>
   <FORM ACTION="/cgi-bin/sisasset.cgi" METHOD="post" name='ha'>
  <input type=hidden name=ss value="$in{ss}">
  <input type=hidden name=pages value=hk001e>
  <input name="pageid" type="hidden" value='$tmp_tgl[3]'>
 <input type=hidden name='usr'>
 <input type=hidden name='action' value='edit'>
 <input name="dep" type="hidden" value='$in{dep}'>
 <input name="subdiv" type="hidden" value='$in{subdiv}'>
 <input name="div" type="hidden" value='$in{div}'>
 ~;
}
print qq~
  <table width='800px' border='0' cellspacing='1' cellpadding='2'>
  <tr bgcolor="$dark">
   <td align='center' class="hurufcol" width=50> No. </td>
   <td align='center' class="hurufcol" width=80> Menu</td>
~;
$q = $dba1->prepare("SELECT NAMAUSR FROM X0000003 WHERE status='1' ORDER BY namausr");
$q->execute();
$i=1;
while (@row = $q->fetchrow_array())
{ print qq~<td align='center' class="hurufcol" width=80> $row[0]~;
  if ($s3s[11] eq 'S')
  {  print qq~<br/><input type=button name='action$i' value='Edit' onClick="validasi('$row[0]')" class=huruf1>~;
  }
  
  print qq~</td>~;
  if ($i==1)
  { $addq = "select  xid, namamenu, namaexe, namaprog, coalesce(b.namausr,'$row[0]') as namausr, b.hwrite from
(select  xid, namamenu, namaexe, namaprog from X0000002 k, X0000001 l
where k.xid=l.recid ) a
 left join
 (select m.namausr, hwrite, exeid from X0000004 m, X0000003 n where m.namausr=n.namausr)
 b on a.namaexe=b.exeid and b.namausr='$row[0]' ";
  }
  else
  { $addq .= "UNION ALL
select  xid, namamenu, namaexe, namaprog, coalesce(b.namausr,'$row[0]') as namausr, b.hwrite from
(select  xid, namamenu, namaexe, namaprog from X0000002 k, X0000001 l
where k.xid=l.recid ) a
 left join
 (select m.namausr, hwrite, exeid from X0000004 m, X0000003 n where m.namausr=n.namausr)
 b on a.namaexe=b.exeid and b.namausr='$row[0]' ";
  }

  $i++;
}

$jmlusr = $i-1;
$colspan = $jmlusr +2;
$q = $dba1->prepare("select  xid, namamenu, namaexe, namaprog, namausr, hwrite from
($addq) order by xid, namaprog, namausr");
$q->execute();
$no=1;
$tmpxid="";
$tmpexe="";
while (@row = $q->fetchrow_array())
{ if ($row[5]) { $hak=$row[5]; }
  else { $hak="&nbsp;"; }

  if ($tmpxid ne  $row[0])
  { print qq~</tr><tr bgcolor=$colcolor height=20> <td class="hurufcol" colspan=$colspan> $row[1]</td>~; }

  if ($tmpexe ne  $row[2])
  { if ($no%2==1) { $bg=$colcolor2; }
    else { $bg=$colcolor3; }
    print qq~
    </tr>
    <tr bgcolor=$bg height=20>
     <td align='center' class="hurufcol" valign="top">$no </td>
     <td class="hurufcol" valign="top">$row[3]</td>
     <td align='center' class="hurufcol" valign="top">$hak</td>
    ~;
    $no++;
  }
  else
  { print qq~<td align='center' class="hurufcol" valign="top">$hak</td>~;
  }

  $tmpxid=$row[0];
  $tmpexe=$row[2];
}

print qq ~
   </tr>
</table>
~;

if ($s3s[11] eq 'S')
{  print qq ~</form>~;
}

print qq ~
    <hr width="100" />
</center>
~;
}

;
1

