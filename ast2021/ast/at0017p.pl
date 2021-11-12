sub at0017p {

&koneksi_ast2;

#genfuncast::view_header($in{ss}, $s3s[2], 'MIS Menyerahkan');
genfuncast::validasi_akses($s3s[11], $in{ss});
use HTML::HTMLDoc;

if($in{recidprint})
{

print qq~
<style>
.hurufprint {
  font-size: 10px;
}
</style>~;
$q = $dba1->do("update kirimh set printke=printke+1, oprupdate='$s3s[0]' where recid='$in{recidprint}' ");

$query = $dba1->prepare("select dtkirim, nosurat, cabang_tuj, namacabang, idlama_tuj, printke, dthrskembali, h.ket
from kirimh h, getstruk c
where  h.cabang_tuj=c.kodecabang and h.recid='$in{recidprint}' ");
$query->execute();
@record = $query->fetchrow_array();
$tglserah = genfuncast::mdytodmy($record[0]);
$printke = $record[5];

if($record[4]!=0)
{
 $q = $dba1->prepare("select nik, nlengkap from getkry where idlama='$record[4]'");
 $q->execute();
 @rec = $q->fetchrow_array();
 $kry = " (".$rec[0]."-".$rec[1].")";
 $namakry = $rec[1];
}
if($namakry eq ''){ $namakry= "..............................."; }
else { $namakry = "<u>$namakry</u>"; }

$query = $dba1->prepare("
select  kode, namajenis, merek, tipe, ukuran, warna, noseri, d.kondisi_asal, namaklp, i.kodeasset
from kirimd d, inventori i, jenisinv j, klpjenisinv k
where i.jenis=j.jenis and d.kodeinv=i.kode and j.klpjenis=k.klpjenis
and kirimid=$in{recidprint} and d.batal='N'  order by namaklp, namajenis
");
$query->execute(); $listbarang=""; $no=1; $tmpklp="";
while(@rec = $query->fetchrow_array())
{ if($tmpklp ne $rec[8])
  { #$listbarang.="
    #    <tr class=hurufprint bgcolor='#dddddd'>
    #       <td colspan=5> <b>$rec[8]</b></td>
    #    </tr>";
  }
  $listbarang.="
        <tr class=hurufprint>
           <td valign='top' align=center> $no</td>
           <td valign='top' align=center> $rec[0]</td>
           <td valign='top' align=center> $rec[9]&nbsp;</td>
           <td valign='top'> $rec[1]</td>
           <td valign='top'> $rec[2] - $rec[3] - $rec[4] - $rec[5] - $rec[6] - $rec[7] </td>
           <!--<td valign='top' align=center> $rec[3]&nbsp; </td>
           <td valign='top' align=center> $rec[4]&nbsp; </td>
           <td valign='top' align=center> $rec[5]&nbsp; </td>
           <td valign='top' align=center> $rec[6]&nbsp; </td>
           <td valign='top' align=center> $rec[7]&nbsp; </td>-->
        </tr>";
   $tmpklp = $rec[8];
   $no++;
}
for ($i=$no; $i<=8; $i++)
{ $listbarang.= qq~
        <tr class=hurufprint>
           <td valign='top' align=center> &nbsp;</td>
           <td valign='top' align=center> &nbsp;</td>
           <td valign='top' align=center> &nbsp;</td>
           <td valign='top'> &nbsp;</td>
           <td valign='top' align=center> &nbsp; </td>
           <!--<td valign='top' align=center> &nbsp; </td>
           <td valign='top' align=center> &nbsp; </td>
           <td valign='top' align=center> &nbsp; </td>
           <td valign='top' align=center> &nbsp; </td>
           <td valign='top' align=center> &nbsp; </td>-->
        </tr>~;
}

$reprint="";
if($printke>1){ $reprint = "(Reprint ke-$printke)"; }
$isi = qq~
<center><h3 class=hurufprint>NOTA PENGIRIMAN BARANG<br/> $reprint</h3></center>
    <table cellpadding="1" cellspacing="0" border=0 width=750>
    <tr class=hurufprint>
        <td width=30 valign='top'>No. </td>
        <td width=130 valign='top'>: $record[1] </td>
        <td width=70 valign='top'>Pengirim</td>
        <td width=400 valign='top'>: MIS <br/>
        </td>
    </tr>
    <tr class=hurufprint>
        <td width=30 valign='top'>Tgl. </td>
        <td width=130 valign='top'>: $tglserah </td>
        <td width=70 valign='top'>Penerima</td>
        <td width=400 valign='top'>: $record[2] - $record[3] $kry</td>
    </tr>
~;
  $isi .=  qq~
    <tr>
        <td colspan=4>
        <table cellpadding="1" cellspacing="0" border=1 width=720>
        <tr class=hurufprint   bgcolor='#eeeeee'>
           <td width=20 valign='top' align=center> No. </td>
           <td width=80 valign='top' align=center> Kode Inv </td>
           <td width=60 valign='top' align=center> Kode Asset </td>
           <td width=120 valign='top' align=center> Nama Inv </td>
           <td width=380 valign='top' align=center> Merek - Tipe - Ukuran - Warna - No. Seri - Kondisi </td>
           <!--<td width=60 valign='top' align=center> Tipe </td>
           <td width=60 valign='top' align=center> Ukuran </td>
           <td width=60 valign='top' align=center> Warna </td>
           <td width=80 valign='top' align=center> No. Seri </td>
           <td width=30 valign='top' align=center> Kondisi </td>-->
        </tr>
         $listbarang
        <tr class=hurufprint  bgcolor='#eeeeee'>
          <td colspan=2>&nbsp;Keterangan </td>
          <td colspan=3>&nbsp;$record[7]</td>
        </tr>
        </table>
        Kondisi: B=Baru, L=Layak <br/>&nbsp;
        </td>
    </tr>
    <tr class=hurufprint>
        <td colspan=4>
        <table cellpadding="2" cellspacing="0" width=600>
         <tr class=hurufprint>
          <td align=center valign='top'>
          Pengirim, <br/> <br/> <br/> <br/> <br/> (...............................)</td>
          <td align=center valign='top'>
          Mengetahui, <br/> <br/> <br/> <br/> <br/> (...............................)</td>
          <td align=center valign='top'>
          Penerima, <br/> <br/> <br/> <br/> <br/> ($namakry)</td>
        </tr>
        </table>
        </td>
    </tr>
</table>~;

$isi2=$isi;
$isi2=~ s/BARANG/BARANG \- COPY/g;

my $htmldoc = new HTML::HTMLDoc('mode'=>'file');
$htmldoc->set_html_content(qq~<html><body>A PDF file</body></html>~);
$htmldoc->set_html_content(qq|
        <!DOCTYPE >
        <html>
        <head></head>
        <body>
        $isi
        </body>
        </html>
        |);

#$htmldoc->set_page_size("A4");
$htmldoc->set_page_size("21x14.8cm");
$htmldoc->set_bodyfont('Arial'); # set font
$htmldoc->set_fontsize('9'); # set font
$htmldoc->set_left_margin(0.8, 'cm'); # set margin
$htmldoc->set_top_margin(0.5, 'cm'); # set margin
$htmldoc->set_bottom_margin(0.5, 'cm'); # set margin
$htmldoc->portrait();
$htmldoc->path("/home/sisasset/htdocs/images/");
$htmldoc->set_logoimage("/home/sisasset/htdocs/images/logosks.jpg");
$htmldoc->set_header('D', '.', ':');
#$htmldoc->set_footer('D', '.', ':');
my $pdf = $htmldoc->generate_pdf();

$direktori ="/home/sisasset/htdocs/tmpast/";
$direktori1 ='tmpast/';
$namafile=$record[1].'.pdf';
$flag = $pdf->to_file($direktori.$namafile);
#print "flag=$flag ".$htmldoc->error();
$temppdf=$direktori.$namafile;
if (-e $temppdf)
{ print qq~
<script>
//doesn't block the load event
function createIframe(){
  var i = document.createElement("iframe");
  i.src = "../$direktori1$namafile";
  i.scrolling = "auto";
  i.frameborder = "0";
  i.width = "1000px";
  i.height = "560px";
  document.getElementById("ifr").appendChild(i);
};

// Check for browser support of event handling capability
if (window.addEventListener)
window.addEventListener("load", createIframe, false);
else if (window.attachEvent)
window.attachEvent("onload", createIframe);
else window.onload = createIframe;

</script>
<div id='ifr'>
    </div>
    <br/><br/>~;
} else { print qq~<br/> File tidak tersedia <br/> ~;
}

}

print qq ~
    <hr width="100" />
</center>
~;
}

;
1

