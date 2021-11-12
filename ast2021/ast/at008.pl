sub at008 {

&koneksi_ast2;

genfuncast::view_header($in{ss}, $s3s[2], 'Master Jenis Inventori');
genfuncast::validasi_akses($s3s[11], $in{ss});

if ($s3s[11] eq 'S' and $in{kd}  && $s3s[7]==0)
{ $q1 = $dba1->do("DELETE FROM STOK WHERE JENISINV='$in{kd}'");
  $q2 = $dba1->do("DELETE FROM JENISINV WHERE JENIS='$in{kd}'");

  if($q1!=0 and $q2!=0)
  { $warning_del = "<div class='warning_ok'>Sukses Hapus Jenis Inventori</div><br/> ";}
  else
  { $warning_del = "<div class='warning_not_ok'>Gagal Hapus Jenis Inventori</div><br/> ";}
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
     <td align=center> <h2 class="hurufcol"> MASTER JENIS INVENTORI</h2> </td>
     ~;
if ($s3s[11] eq 'S')
{     print qq~<td align=right width=100>
      <!--<a href='/cgi-bin/colorbox.cgi?proses=str000&display=at008a' class='iframe'>Add Jenis Inv</a>-->
      
      <form method=post action="/cgi-bin/sisasset.cgi" >
      <input type="submit" name="back" value="Tambah" class="huruf1"/>
      <input name="pages" type="hidden" value=at008a>
      <input name="ss" type="hidden" value="$in{ss}"> </form> </td> ~;
}     print qq~
     </tr>
     </table>
    <form action="/cgi-bin/sisasset.cgi" method="post" name='vq'>
  <input type=hidden name=ss value="$in{ss}">
  <input type=hidden name=pages value=at008>
<table>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=100> &nbsp;Kelompok Jenis </td>
    <td class="hurufcol" ><select name="katmenu" class="huruf1" id="katmenu">
    <option value=''>-</option>~;
$query = $dba1->prepare("SELECT klpjenis,namaklp FROM KLPJENISINV ORDER BY klpjenis ");
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
          { pages.value='at008';
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
          { pages.value='at008';
            child.value=n;
           submit();
          }
        }
}
function toedit(n)
{  with(document.mst)
   { pages.value='at008e';
     kd.value=n;
     submit();
   }
}
function toaddsub(n)
{  with(document.mst)
   { pages.value='at008b';
     kd.value=n;
     submit();
   }
}
</script>
 $warning_del
   <FORM ACTION="/cgi-bin/sisasset.cgi" METHOD="post" name='mst'>
  <input type=hidden name=ss value="$in{ss}">
  <input type=hidden name=pages value=at008>
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
   <td align='center' class="hurufcol" width=100> Kelompok Jenis </td>
   <td align='center' class="hurufcol" width=100> Kode Jenis Inventori </td>
   <td align='center' class="hurufcol" width=270> Nama Inventori </td>
   <td align='center' class="hurufcol" width=50> Counter </td>
   <td align='center' class="hurufcol" width=120> Action</td>
  </tr>
~;

$subq="";
if($in{katmenu}) { $subq=" where klpjenis='$in{katmenu}'"; }
$q = $dba1->prepare("select jenis,namajenis,klpjenis, counter from JENISINV $subq order by klpjenis, jenis ");
$q->execute();
$no=1;
$tmpkat = '';
while (@row = $q->fetchrow_array())
{
  if ($s3s[11] eq 'S')
  { $btn = "
    <input type='image' src='/images/edit.png' name='edt$no' value='Edit' class='huruf1' onClick=\"toedit('$row[0]');\">&nbsp;
    <input type='image' src='/images/del.png' name='del$no' value='Delete' class='huruf1' onClick=\"validasi('$row[0]');\">"; }
  else { $btn=""; }
  
  $link="$row[3]";
  if($row[3]>0){ $link =qq~ <a class=huruflink href="sisasset.cgi?pages=at0010&jen=$row[0]&ss=$in{ss}" target='_blank'>$row[3]</a>~; }
  
  if($no%2==1){ $bg=$colcolor; }
  else { $bg=$colcolor2; }
  print qq~
  <tr bgcolor=$bg height=20>
     <td align='center' class="hurufcol" valign="top">$no </td>
     <td align='center' class="hurufcol" valign="top">$row[2] </td>
     <td align='center' class="hurufcol" valign="top">$row[0] </td>
     <td class="hurufcol" valign="top">$row[1]</td>
     <td align='center' class="hurufcol" valign="top">$link</td>
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

