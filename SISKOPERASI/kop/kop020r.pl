sub kop020r {

genfunckop::view_header_kop($in{ss}, $s3s[2], 'Pencairan Iuran', $s3s[17]);
genfunckop::validasi_akses_kop($s3s[11], $in{ss});
&koneksi_kop2;

($month,$day,$year,$weekday) = &jdate(&today());
$month = substr "0".$month, -2;
$day = substr "0".$day, -2;
$today = $month."/".$day."/".$year;
if(!$in{dtcair}) { $in{dtcair}=$today; }

print qq~
     <table width=1000 border="0" cellspacing="0" cellpadding="0">
     <tr>
     <td align=right width=50><form method=post action="/cgi-bin/siskop.cgi" >
      <input type="submit" name="back" value="Back" class="huruf1"/>
      <input name="pages" type="hidden" value=kop020>
      <input name="ss" type="hidden" value="$in{ss}"> </form>
      </td>
     <td align=center> <h2 class="hurufcol">PENCAIRAN IURAN </h2> </td>
      <td align=right width=50>&nbsp;
      </td>
     </tr>
     </table>
~;

print qq~
<script type='text/javascript' src='/jquery.min.js'></script>
<script type='text/javascript' src="/jquery.chained.js"></script>
<style type="text/css">
\@import url("/jscalendar/calendar-blue.css");
</style>

<script type="text/javascript" src="/jscalendar/calendar.js"></script>
<script type="text/javascript" src="/jscalendar/lang/calendar-en.js"></script>
<script type="text/javascript" src="/jscalendar/calendar-setup.js"></script>

<script type='text/javascript' src='/jquery-ui.js'></script>
<link rel="stylesheet" href="/jquery-ui.css">
<style>
  .ui-autocomplete-category {
    font-weight: bold;
    padding: .2em .4em;
    margin: .8em 0 .2em;
    line-height: 1.5;
  }
  </style>
  <script>
  \$.widget( "custom.catcomplete", \$.ui.autocomplete, {
    _create: function() {
      this._super();
      this.widget().menu( "option", "items", "> :not(.ui-autocomplete-category)" );
    },
    _renderMenu: function( ul, items ) {
      var that = this,
        currentCategory = "";
      \$.each( items, function( index, item ) {
        var li;
        if ( item.category != currentCategory ) {
          ul.append( "<li class='ui-autocomplete-category'>" + item.category + "</li>" );
          currentCategory = item.category;
        }
        li = that._renderItemData( ul, item );
        if ( item.category ) {
          li.attr( "aria-label", item.category + " : " + item.label );
        }
      });
    }
  });
  </script>
  <script>
  \$(function() {
    var data = [
~;
$query = $dbk->prepare("
select nik, nlengkap, kodecabang  from anggota a, getkry k
where a.idlama=k.idlama and a.aktif!='Z' and a.idlama not in (select idlama from pinjaman where lunas='N')  order by nlengkap ");
$query->execute();
while (@rec = $query->fetchrow_array())
{  $str.= qq~ { label: "$rec[0] - $rec[1]", category: "$rec[2]" },~ ;
}
$n = length($str) - 1;
$str = substr $str,0,$n;

print qq~
      $str
    ];

    \$( "#nikgo" ).catcomplete({
      delay: 0,
      source: data
    });
  });
  </script>

~;

@yesno = ('Y', 'N');
@simp = ('S', 'P');
@simp_text = ('Sukarela','Pokok');
print qq~
<form action="/cgi-bin/siskop.cgi" method="post" name='vq'>
  <input type=hidden name=ss value="$in{ss}">
  <input type=hidden name=pages value=kop020r>
<table>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=150> &nbsp; Karyawan </td>
    <td class="hurufcol"> <input type=text name=nikgo id=nikgo value="$in{nikgo}" class=huruf1 size=40 maxlength="50" style="text-transform: uppercase"></td>
  </tr>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol"> &nbsp; Tgl Pencairan </td>
    <td class="hurufcol" ><input class='huruf1' name="dtcair" type="text" id="dtcair" size="12" maxlength="12" value="$in{dtcair}" />
       <img src="/jscalendar/img.gif" id="trigger3" style="cursor: pointer; border: 1px solid blue;" title="Date selector" onMouseOver="this.style.background='blue';" onMouseOut="this.style.background=''" />
       <script type="text/javascript">
       Calendar.setup(
       {
        inputField  : "dtcair",         // ID of the input field
        ifFormat    : "%m/%d/%Y",    // the date format
        button      : "trigger3"       // ID of the button
	  //daFormat  :  "%Y/%m/%d"
        }
       );
       </script>
    </td>
    </tr>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=150 valign=top> &nbsp; Jenis Simpanan </td>
    <td class="hurufcol">
    ~;
    for ($i=0; $i<@simp; $i++)
    { $j=$i+1;
      $selected="";
      if($in{"simpanan$j"} eq $simp[$i]){ $selected='checked';}
      print qq~<input type=checkbox name=simpanan$j value='$simp[$i]' $selected> $simp_text[$i]  &nbsp; &nbsp;<br/> ~;
    }
    print qq~ <br/> <i>*Pencairan Simpanan Pokok akan otomatis menonaktifkan Anggota</i></td>
  </tr>
</table><input type='submit' name='view' value='View'>
~;
if($in{view})
{
  $wrn='';
  if (!($in{nikgo})) { $wrn.="<li>Karyawan</li>"; }
  if (!($in{dtcair})) { $wrn.="<li>Tgl Pencairan</li>"; }

  if ($wrn ne "" )
  {  print "<div class='warning_not_ok'>Isilah field-field di bawah dengan format yang benar: $wrn</div><br/>";
  }
  else
  {
    $in{nikgo} = substr $in{nikgo},0,9;
    $in{nikgo} = uc $in{nikgo} ;
    $query = $dbk->prepare("select idlama from getkry where nik='$in{nikgo}' ");
    $query->execute();
    @rec = $query->fetchrow_array();
    $idlama = $rec[0];
  
    print qq~<table border=0 cellspacing=5 cellpadding=0 width=800>
    <tr bgcolor=$colcolor height=20>
    ~;
    for ($i=1; $i<=2; $i++)
    {if($in{"simpanan$i"})
     { print qq~<td>
      <table border=1 cellspacing=0 cellpadding=2 width=400>
        <tr bgcolor=$dark height=20 class=hurufcol>
          <td align=center><b>No</b></td>
          <td align=center><b>Periode</b></td>
          <td align=center><b>Simpanan $in{"simpanan$i"}</b></td>
        </tr> ~;
      $flag=$in{"simpanan$i"};
      $query = $dbk->prepare("select periode, hrsbayar, recid from iuran where idlama = $idlama   and jenis='".$in{"simpanan$i"}."' and minusid is null  ");
      $query->execute();
      $no=1; $jml=0; $ctr=1;
      while (@rec = $query->fetchrow_array())
      { $txt = genfuncpyl::ribuan($rec[1]);
        print qq~
        <tr bgcolor=$colcolor height=20 class=hurufcol>
          <td align=center>$no</td>
          <td align=center>$rec[0]</td>
          <td align=right>$txt <input type=hidden name='recid$flag$ctr' value=$rec[2]></td>
        </tr> ~;
        $jml+=$rec[1];
        $no++; $ctr++;
      }
      $txttotal = genfuncpyl::ribuan($jml);
      $ctr--;
      print qq~
        <tr bgcolor=$dark height=20 class=hurufcol>
          <td align=center>&nbsp;</td>
          <td align=center><b>TOTAL</b></td>
          <td align=right><b>$txttotal</b></td>
        </tr>
        </table>
        <input type=hidden name='maxctr$flag' value=$ctr>
        </td> ~;
     }
    }

    print qq~ </tr>
    </table>
    <input type=hidden name='idlama' value=$idlama>
    ~;
    if($no>1){ print qq~<input type='submit' name='simpan' value='Simpan'>~; }
  }
}

print qq~</form>    ~;

if($in{simpan})
{
     $prid = genfunckop::getPeriodeKop($in{dtcair});
     
     $subq = "";   $nonaktif=0;
     for ($i=1; $i<=2; $i++)
     { if($in{"simpanan$i"})
       {  $subq .= " or jenis='".$in{"simpanan$i"}."'";
          if($i==2){ $nonaktif=1; $qn = $dbk2->do("update anggota set aktif='N' where idlama = '$in{idlama}';");  }
       }
     }
     $subq = substr $subq,4;
     
     $query = $dbk->prepare("select max(recid) from minus ");
     $query->execute();
     @rec = $query->fetchrow_array();
     $recidm = $rec[0]+1;
     $ok=0;

     $query = $dbk->prepare("select jenis, count(*), sum(hrsbayar) from iuran where idlama = $in{idlama} group by jenis having ($subq) ");
     $query->execute(); $no=1;
     while (@rec = $query->fetchrow_array())
     { $q = $dbk2->do("INSERT INTO MINUS (RECID, PERIODE, IDLAMA, KETERANGAN, JUMLAH, DTTRANSAKSI, KATEGORI, OPRCREATE) VALUES
        ('$recidm','$prid', $in{idlama}, '$rec[0] - $rec[1]', $rec[2], '$in{dtcair}', 'PS', '$s3s[0]' );");
       if($q!=0)
       { $sukses=0;
         for($i=1; $i<=$in{"maxctr$rec[0]"}; $i++)
         { $qd = $dbk2->do("update iuran set minusid='$recidm', oprupdate='$s3s[0]' where recid='".$in{"recid$rec[0]$i"}."'");
           if($qd!=0){ $sukses++; }
         }
         if($sukses==$rec[1]){ $ok[$no]=1; }
         else { $ok[$no]=0; }
       }
       $recidm++;
       $no++;
     }
     
     if($ok[1]==1 and $ok[2]==1) { print qq~<div class=warning_ok>Sukses Pencairan Simpanan</div> ~; }
     else { print qq~<div class=warning_not_ok>Gagal Pencairan Simpanan</div> ~; }

     if($nonaktif==1 and $qn!=0)
     { print qq~<div class=warning_ok>Sukses Nonaktifkan Anggota</div>~; }
}

print qq ~
    <hr width="100" />
</center>
~;
}

;
1

