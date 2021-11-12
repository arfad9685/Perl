sub at004 {

&koneksi_ast2;

genfuncast::view_header($in{ss}, $s3s[2], 'Master Menu');
genfuncast::validasi_akses($s3s[11], $in{ss});

if ($s3s[11] eq 'S' and $in{kd}  && $s3s[7]==0)
{ $postall = $dba1->do("DELETE FROM X0000005  WHERE parent='$in{kd}'");
  $postall = $dba1->do("DELETE FROM X0000004  WHERE exeid='$in{kd}'");
  $postall = $dba1->do("DELETE FROM X0000002  WHERE namaexe='$in{kd}'");
  $warning_del="<div class='warning_ok'>Sukses Hapus Menu </div><br/>";
}
if ($s3s[11] eq 'S' and $in{child}  && $s3s[7]==0)
{ $postall = $dba1->do("DELETE FROM X0000005  WHERE child='$in{child}'");
  $warning_del="<div class='warning_ok'>Sukses Hapus Submenu </div><br/>";
}

print qq~
<link rel="stylesheet" href="/colorbox.css" />
<script type="text/javascript" src="/jquery.min.js"></script>
<script type="text/javascript" src="/jquery.colorbox.js"></script>

<script type="text/javascript">
\$(document).ready(function(){
   \$(".iframe").colorbox({
      iframe:true,
      width:"900",
      height:"80%"});

    \$("#click").click(function(){
	 \$(".iframe").colorbox.close();
    });

    \$(".print-invoice").click(function() {
      \$(".iframe").get(0).contentWindow.print();
    });

});

</script>
~;
print qq~
     <table width=1000 border="0" cellspacing="0" cellpadding="0">
     <tr>
     <td align=left width=100>
     &nbsp;
     </td>
     <td align=center> <h2 class="hurufcol"> MASTER MENU</h2> </td>
     ~;
if ($s3s[11] eq 'S')
{     print qq~<td align=right width=100>
      <!--<a href='/cgi-bin/colorbox.cgi?proses=str000&display=at004a' class='iframe'>Add Menu</a>-->
      
      <form method=post action="/cgi-bin/sisasset.cgi" >
      <input type="submit" name="back" value="Add Menu" class="huruf1"/>
      <input name="pages" type="hidden" value=at004a>
      <input name="ss" type="hidden" value="$in{ss}"> </form> </td> ~;
}     print qq~
     </tr>
     </table>
<form action="/cgi-bin/sisasset.cgi" method="post" name='vq'>
  <input type=hidden name=ss value="$in{ss}">
  <input type=hidden name=pages value=at004>
<table>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=100> &nbsp;Kategori Menu </td>
    <td class="hurufcol" ><select name="katmenu" class="huruf1" id="katmenu">
    <option value=''>-</option>~;
$query = $dba1->prepare("SELECT recid, namamenu FROM  X0000001  ORDER BY urutan ");
$query->execute();
while (@rec = $query->fetchrow_array())
{  $selected="";
   if ($in{katmenu} eq $rec[0]) { $selected="selected"; }
   print qq~<option value='$rec[0]' $selected> $rec[1] </option>~;
}
print qq~
    </select>
    </td>
    <td><input type='submit' name='search' value='Search'> </td>
  </tr>
</table>
</form>
     ~;
if ($s3s[11] eq 'S')
{
print qq ~
<script type="text/javascript">
function validasi(n)
{
      var result = confirm("Are you sure to delete?");
        if (result==true) {
          with(document.mst)
          { pages.value='at004';
            kd.value=n;
           submit();
          }
        }
}
function validasi2(n)
{
      var result = confirm("Are you sure to delete?");
        if (result==true) {
          with(document.mst)
          { pages.value='at004';
            child.value=n;
           submit();
          }
        }
}
function toedit(n)
{  with(document.mst)
   { pages.value='at004e';
     kd.value=n;
     submit();
   }
}
function toaddsub(n)
{  with(document.mst)
   { pages.value='at004b';
     kd.value=n;
     submit();
   }
}
</script>
 $warning_del
   <FORM ACTION="/cgi-bin/sisasset.cgi" METHOD="post" name='mst'>
  <input type=hidden name=ss value="$in{ss}">
  <input type=hidden name=pages value=at004>
  <input name="pageid" type="hidden" value='$tmp_tgl[3]'>
 <input type=hidden name='kd'>
 <input type=hidden name='child'>
 <input type=hidden name='parent'>
 <input type=hidden name='action' value='delete'>
 ~;
}
print qq~
<script type='text/javascript' src='/jquery.min.js'></script>
  <table width='820px' border='0' cellspacing='1' cellpadding='2'>
  <tr bgcolor="$dark">
   <td align='center' class="hurufcol" width=50> No. </td>
   <td align='center' class="hurufcol" width=100> Kategori Menu</td>
   <td align='center' class="hurufcol" width=370> Menu </td>
   <td align='center' class="hurufcol" width=100> Nama Program </td>
   <td align='center' class="hurufcol" width=80> Visibility</td>
   <td align='center' class="hurufcol" width=80> Last Prg</td>
   <td align='center' class="hurufcol" width=120> Action</td>
  </tr>
~;

$subq="";
if($in{search}) { $subq=" AND b.xid='$in{katmenu}'"; }

$q = $dba1->prepare("select namamenu,  namaprog, namaexe, ex_in, lastprg from X0000001 a, X0000002 b WHERE a.recid=b.xid $subq order by namamenu, namaprog ");
$q->execute();
$no=1;
$tmpkat = '';
while (@row = $q->fetchrow_array())
{ $q2 = $dba2->prepare("SELECT child, ketchild, parent  FROM  X0000005 WHERE parent='$row[2]' ORDER BY child ");
  $q2->execute();
  $div="<ul>";
  $j=1;
  while (@row2 = $q2->fetchrow_array())
  {  if ($s3s[11] eq 'S' and $row2[0] ne $row2[2])
     { $btn2 = "<input type='image' src='/images/del.png' name='del2$no_$j' value='Delete' class='huruf1' onClick=\"validasi2('$row2[0]');\">"; }
     else { $btn2=""; }
     $div.= "<li> $row2[0] - $row2[1]  $btn2 </li> ";
     $j++;
  }
  $div.="</ul>";

  if ($s3s[11] eq 'S')
  { $btn = "
    <input type='image' src='/images/add.png' name='add$no' value='Add Submenu' class='huruf1' onClick=\"toaddsub('$row[2]');\"> &nbsp;
    <input type='image' src='/images/edit.png' name='edt$no' value='Edit' class='huruf1' onClick=\"toedit('$row[2]');\">&nbsp;
    <input type='image' src='/images/del.png' name='del$no' value='Delete' class='huruf1' onClick=\"validasi('$row[2]');\">"; }
  else { $btn=""; }

  if ($tmpkat and $tmpkat ne $row[0]) { print qq~<tr bgcolor=$dark height=5><td colspan=8></td> </tr>~; }
  print qq~
  <tr bgcolor=$colcolor height=20>
     <td align='center' class="hurufcol" valign="top">$no </td>
     <td align='center' class="hurufcol" valign="top">$row[0]</td>
     <td class="hurufcol" valign="top"><a href="#" class="hide hurufcol">$row[1] </a>
        <div class="data">
           $div
        </div></td>
     <td align='center' class="hurufcol" valign="top">$row[2]</td>
     <td align='center' class="hurufcol" valign="top">$row[3]</td>
     <td align='center' class="hurufcol" valign="top">$row[4]</td>
     <td align='center' valign="top">$btn </td>
  </tr>
  ~;
  $no++;
  $tmpkat=$row[0];
}

print qq ~</table>
<script type='text/javascript'>
\$( 'div.data' ).hide();
\$('a.hide').click(function(e){
   e.preventDefault();
   var div =\$(this).next('div.data').slideToggle();
});
</script>
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

