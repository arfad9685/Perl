sub at006 {

&koneksi_ast2;

genfuncast::view_header($in{ss}, $s3s[2], 'Master Tipe Inventori');
genfuncast::validasi_akses($s3s[11], $in{ss});

if ($s3s[11] eq 'S' and $in{kd}  && $s3s[7]==0)
{ $postall = $dba1->do("DELETE FROM TIPEINV WHERE TIPE='$in{kd}'");
        if($postall!=0)
        { $warning_del = "<div class='warning_ok'>Sukses Hapus Tipe</div><br/> ";}
        else { $warning_del = "<div class='warning_not_ok'>Gagal Hapus Tipe</div><br/> ";}
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
     <td align=center> <h2 class="hurufcol"> MASTER TIPE INVENTORI </h2> </td>
     ~;
if ($s3s[11] eq 'S')
{     print qq~<td align=right width=100>
      <!--<a href='/cgi-bin/colorbox.cgi?proses=str000&display=at006a' class='iframe'>Add Tipe Inv</a>-->

      <form method=post action="/cgi-bin/sisasset.cgi" >
      <input type="submit" name="back" value="Tambah" class="huruf1"/>
      <input name="pages" type="hidden" value=at006a>
      <input name="ss" type="hidden" value="$in{ss}"> </form> </td> ~;
}     print qq~
     </tr>
     </table>
    <form action="/cgi-bin/sisasset.cgi" method="post" name='vq'>
  <input type=hidden name=ss value="$in{ss}">
  <input type=hidden name=pages value=at006>
<table>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=100> &nbsp;Jenis Inventori </td>
    <td class="hurufcol" ><select name="katmenu" class="huruf1" id="katmenu">
    <option value=''>-</option>~;
$query = $dba1->prepare("SELECT jenis,namajenis FROM JENISINV ORDER BY namajenis ");
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
          { pages.value='at006';
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
          { pages.value='at006';
            child.value=n;
           submit();
          }
        }
}
function toedit(n)
{  with(document.mst)
   { pages.value='at006e';
     kd.value=n;
     submit();
   }
}
function toaddsub(n)
{  with(document.mst)
   { pages.value='at006b';
     kd.value=n;
     submit();
   }
}
</script>
 $warning_del
   <FORM ACTION="/cgi-bin/sisasset.cgi" METHOD="post" name='mst'>
  <input type=hidden name=ss value="$in{ss}">
  <input type=hidden name=pages value=at006>
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
   <td align='center' class="hurufcol" width=100> Jenis Inventori </td>
   <td align='center' class="hurufcol" width=100> Tipe Inventori </td>
   <td align='center' class="hurufcol" width=120> Action</td>
  </tr>
~;

$subq="";
if($in{katmenu} ne '') { $subq=" where jenis='$in{katmenu}'"; }
#print qq~select tipe,jenis,namatipe from tipeinv $subq order by namatipe~;
$q = $dba1->prepare("select tipe,jenis,namatipe from tipeinv $subq order by namatipe ");
$q->execute();
$no=1;
$tmpkat = '';
while (@row = $q->fetchrow_array())
{ if ($s3s[11] eq 'S')
  { $btn = "
    <!--<input type='image' src='/images/edit.png' name='edt$no' value='Edit' class='huruf1' onClick=\"toedit('$row[0]');\">&nbsp;-->
    <input type='image' src='/images/del.png' name='del$no' value='Delete' class='huruf1' onClick=\"validasi('$row[0]');\">"; }
  else { $btn=""; }

  if($no%2==1){ $bg=$colcolor; }
  else { $bg=$colcolor2; }
  print qq~
  <tr bgcolor=$bg height=20>
     <td align='center' class="hurufcol" valign="top">$no </td>
     <td align='center' class="hurufcol" valign="top">$row[1] </td>
     <td align='center' class="hurufcol" valign="top">$row[0] </td>
     <td align='center' valign="top">$btn </td>
  </tr>
  ~;
  $no++;
  $tmpkat=$row[0];
}

print qq ~</table>

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

