sub at0011 {

&koneksi_ast2;

genfuncast::view_header($in{ss}, $s3s[2], 'Master Warna');
genfuncast::validasi_akses($s3s[11], $in{ss});

if ($s3s[11] eq 'S' and $in{kd}  && $s3s[7]==0)
{ $postall = $dba1->do("DELETE FROM WARNA  WHERE WARNA='$in{kd}'");
        if($postall!=0)
        { $warning_del = "<div class='warning_ok'>Sukses Hapus Warna</div><br/> ";}
        else { $warning_del = "<div class='warning_not_ok'>Gagal Hapus Warna</div><br/> ";}
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
     <td align=center> <h2 class="hurufcol"> MASTER WARNA</h2> </td>
     ~;
if ($s3s[11] eq 'S')
{     print qq~<td align=right width=100>
      <!--<a href='/cgi-bin/colorbox.cgi?proses=str000&display=at0011a' class='iframe'>Add Warna</a>-->
      
      <form method=post action="/cgi-bin/sisasset.cgi" >
      <input type="submit" name="back" value="Tambah" class="huruf1"/>
      <input name="pages" type="hidden" value=at0011a>
      <input name="ss" type="hidden" value="$in{ss}"> </form> </td> ~;
}     print qq~
     </tr>
     </table>

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
          { pages.value='at0011';
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
          { pages.value='at0011';
            child.value=n;
           submit();
          }
        }
}
function toedit(n)
{  with(document.mst)
   { pages.value='at0011e';
     kd.value=n;
     submit();
   }
}
function toaddsub(n)
{  with(document.mst)
   { pages.value='at0011b';
     kd.value=n;
     submit();
   }
}
</script>
 $warning_del
   <FORM ACTION="/cgi-bin/sisasset.cgi" METHOD="post" name='mst'>
  <input type=hidden name=ss value="$in{ss}">
  <input type=hidden name=pages value=at0011>
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
   <td align='center' class="hurufcol" width=20> No. </td>
   <td align='center' class="hurufcol" width=80> Kode Warna</td>
   <td align='center' class="hurufcol" width=100> Nama Warna </td>
   <td align='center' class="hurufcol" width=80> Action</td>
  </tr>
~;

$q = $dba1->prepare("select warna, namawarna from warna $subq order by warna,namawarna ");
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
  
  if($no%2==1){ $bg=$colcolor; }
  else { $bg=$colcolor2; }
  print qq~
  <tr bgcolor=$bg height=20>
     <td align='center' class="hurufcol" valign="top">$no </td>
     <td align='center' class="hurufcol" valign="top">$row[0]</td>
     <td class="hurufcol" valign="top">$row[1]
        </td>
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

