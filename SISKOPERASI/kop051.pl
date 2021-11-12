sub kop051{

&koneksi_kop2;

genfunckop::view_header_kop($in{ss}, $s3s[2], 'Master Barang');

if  ($in{curprod})
   {
   @prd=split(/\-/,$in{curprod});
   $brgid = $prd[0];
   $query = $dbk->prepare("select brg_id,brg_nama from getproduk where brg_id='$brgid'");
       $query->execute();
       @row = $query->fetchrow_array();
       $idbrg=$row[0];
       
     }
     else { $idbrg="0"; 
	 
	 }
	 
#print "DELETE FROM M_PRODUK_KOP WHERE recid='$in{kd}'";
if ($s3s[11] eq 'S' and $in{kd}  && $s3s[7]==0)
{ $postall = $dbk->do("DELETE FROM M_PRODUK_KOP WHERE recid='$in{kd}'");
        if($postall!=0)
        { $warning_del = "<div class='warning_ok'>Sukses Hapus Barang</div><br/> ";}
        else { $warning_del = "<div class='warning_not_ok'>Gagal Hapus Barang</div><br/> ";}
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
     <td align=center> <h2 class="hurufcol"> MASTER BARANG</h2> </td>
     ~;
#if ($s3s[11] eq 'S')
    print qq~<td align=right width=100>
      <!--<a href='/cgi-bin/colorbox.cgi?proses=str000&display=at007a' class='iframe'>Add Jenis</a>-->
      
      <form method=post action="/cgi-bin/siskop.cgi" >
      <input type="submit" name="back" value="Tambah" class="huruf1"/>
      <input name="pages" type="hidden" value=kop051a>
      <input name="ss" type="hidden" value="$in{ss}"> </form> </td> ~;
    print qq~
     </tr>
     </table>

     ~;
if ($s3s[11] eq 'S')
{
print qq ~
<script type="text/javascript">
function validasi(n)
{
      var result = confirm("Yakin Hapus Barang?");
        if (result==true) {
          with(document.mst)
          { pages.value='kop051';
            kd.value=n;
           submit();
          }
        }
}

function toedit(n)
{  with(document.mst)
   { pages.value='kop051e';
     kd.value=n;
     submit();
   }
}

</script>
 $warning_del
   <FORM ACTION="/cgi-bin/siskop.cgi" METHOD="post" name='mst'>
  <input type=hidden name=ss value="$in{ss}">
  <input type=hidden name=pages value=kop051>
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
   <td align='center' class="hurufcol" width=100> Kode Barang </td>
   <td align='center' class="hurufcol" width=370> Nama Barang </td>
   <td align='center' class="hurufcol" width=100> Harga Barang </td>
   <td align='center' class="hurufcol" width=120> Action</td>
  </tr>
~;

$q = $dbk->prepare("select brg_id,brg_nama,harga,recid from m_produk_kop
where isaktif='Y' order by 2 asc ");
$q->execute();
$no=1;
$tmpkat = '';
while (@row = $q->fetchrow_array())
{
   $btn = "
    <input type='image' src='/images/edit.png' name='edt$no' value='Edit' class='huruf1' onClick=\"toedit('$row[3]');\">&nbsp;
    <input type='image' src='/images/del.png' name='del$no' value='Delete' class='huruf1' onClick=\"validasi('$row[3]');\">"; 
  
  if($no%2==1){ $bg=$colcolor; }
  else { $bg=$colcolor2; }
  print qq~
  <tr bgcolor=$bg height=20>
     <td align='center' class="hurufcol" valign="top">$no </td>
     <td align='center' class="hurufcol" valign="top">$row[0]</td>
	 <td align='left' class="hurufcol" valign="top">$row[1]</td>
     <td class="hurufcol" valign="top">$row[2]</td>
     <td align='center' valign="top">$btn </td>
  </tr>
  ~;
  $no++;
  $tmpkat=$row[0];
}

print qq ~</table>

~;

 print qq ~</form>~;

print qq ~
    <hr width="100" />
</center>
~;
}

;
1

