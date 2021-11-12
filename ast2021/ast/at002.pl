sub at002 {

#&prtstatipxx;
#print qq~depid=$s3s[13]~;
use Date::Calc qw(Add_Delta_Days);
use Date::Calc qw(Day_of_Week);
use Date::Calc qw(Days_in_Month);
genfuncast::view_header($in{ss}, $s3s[2], 'HOME');

($month,$day,$year,$weekday) = &jdate(&today());
$month = substr "0".$month, -2;
$day = substr "0".$day, -2;
$today = $month."/".$day."/".$year;

print qq~
  <table width='500px' border='0' cellspacing='1' cellpadding='3'>
  <tr bgcolor="$dark">
   <td align='center' class="hurufcol"> <b>ALERT SISASSET</b> </td>
  </tr>


  ~;
$q = $dba1->prepare("select count(*) from kirimh h, kirimd d where h.recid=d.kirimid and flagpinjam='Y' and jenis='S' and h.batal='N'
 and kembaliid is null");
$q->execute();
@row = $q->fetchrow_array();
if ($row[0]>0)
{ print qq~<tr bgcolor="$colcolor" class="hurufcol">
      <td><a href="/cgi-bin/sisasset.cgi?pages=at0020&ss=$in{ss}" class=hurufcol>Peminjaman Belum Kembali : $row[0]</a></td>
      </tr> ~;
      $n++;
}

print " </table>
<hr width=100/> ";
}

;
1

