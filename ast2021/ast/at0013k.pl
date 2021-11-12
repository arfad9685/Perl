sub at0013k {

&koneksi_ast2;
$xtin=0;

genfuncast::view_header($in{ss}, $s3s[2], 'Kembalikan Inventori Pinjaman');
genfuncast::validasi_akses($s3s[11], $in{ss});

@kondisi = ('L','R');
@kondisitext = ('Layak','Rusak');

@kodeinv = ('Y');
@kodeinvt = ('Yes');

if ($in{simpan})
{ $sukses=0;

  $idlama = $in{idlama};
  if($in{cabang})  { $cabangasal=$in{cabang}; }
  else { $cabangasal = $in{cabangasal}; }
  $nosurat = genfuncast::generate_nosuratt($in{tgtrm}, $dba1);

  $query = $dba1->prepare("select max(recid) from kirimh  ");
  $query->execute();
  @row = $query->fetchrow_array();
  if($row[0]){ $recid=$row[0]+1; }
  else { $recid=1; }

  $jmlkembali=0;
  for ($i=1; $i<=$in{baris}; $i++)
  {   if($in{"kodeinv$i"}){$jmlkembali++;}
  }

 if($jmlkembali==0)
 { $warning = "<div class=warning_not_ok>Tidak ada Inventori yang dikembalikan</div>"; }
 else
 {
  if($xtin==1){ print("INSERT INTO KIRIMH (RECID, NOSURAT, DTKIRIM, CABANG_TUJ, IDLAMA_TUJ, OPRCREATE, JENIS, KET, flagpinjam) VALUES
                    ($recid, '$nosurat', '$in{tgtrm}', '$in{tujuan}', '0', '$s3s[0]', 'T','$in{ket}','K');"); }

  $q1 = $dba1->do("INSERT INTO KIRIMH (RECID, NOSURAT, DTKIRIM, CABANG_TUJ, IDLAMA_TUJ, OPRCREATE, JENIS, KET, flagpinjam) VALUES
                    ($recid, '$nosurat', '$in{tgtrm}', '$in{tujuan}', '0', '$s3s[0]', 'T','$in{ket}','K');");

  if($q1!=0)
  {
     $jml=0;

     #print"b= $in{baris}";
     for ($i=1; $i<=$in{baris}; $i++)
     {   if($in{"kodeinv$i"})
         { $jml++;

           if($xtin==1){ print("INSERT INTO KIRIMD (KIRIMID, KODEINV, CABANG_ASAL, IDLAMA_ASAL, OPRCREATE,  KONDISI, KET,KONDISI_ASAL,KET_ASAL) VALUES
           ($recid, '".$in{"kodeinv$i"}."', '$cabangasal','$idlama', '$s3s[0]','".$in{"kondisi$i"}."','".$in{"keterangan$i"}."',
           '".$in{"kondisiasal$i"}."','".$in{"ketasal$i"}."');<br/> "); }

           $q2 = $dba1->do("INSERT INTO KIRIMD (KIRIMID, KODEINV, CABANG_ASAL, IDLAMA_ASAL, OPRCREATE,  KONDISI, KET,KONDISI_ASAL,KET_ASAL) VALUES
           ($recid, '".$in{"kodeinv$i"}."', '$cabangasal','$idlama', '$s3s[0]','".$in{"kondisi$i"}."','".$in{"keterangan$i"}."',
           '".$in{"kondisiasal$i"}."','".$in{"ketasal$i"}."');");
           
             $jenisinv = substr $in{"kodeinv$i"},0,6;
             $in{tgtrm} = genfuncast::formatMDY($in{tgtrm});
             ($m,$d,$y)=genfuncast::getMdy($in{tgtrm});
             $m=substr "0$m",-2;
             $periode = $y."-".$m;
           if($q2!=0)
           {  $q3 = $dba1->do("update stok set pnjterima=pnjterima+1, oprupdate='$s3s[0]' where jenisinv='$jenisinv';"); }

           if($q3!=0)
           { if($xtin==1){ print("update inventori set kondisi='".$in{"kondisi$i"}."',keterangan='".$in{"keterangan$i"}."',
              currcabang='$in{tujuan}', curridlama='0', oprupdate='$s3s[0]', flagpinjam='N', dtlastkirim='$in{tgtrm}' where kode='".$in{"kodeinv$i"}."'; <br/> "); }
             $q3 = $dba1->do("update inventori set kondisi='".$in{"kondisi$i"}."',keterangan='".$in{"keterangan$i"}."',
              currcabang='$in{tujuan}', curridlama='0', oprupdate='$s3s[0]', flagpinjam='N', dtlastkirim='$in{tgtrm}' where kode='".$in{"kodeinv$i"}."';");
             if($q3!=0)
             {   $query = $dba1->prepare("
                  select d.recid from kirimh h, kirimd d where h.recid=d.kirimid and h.idlama_tuj=$idlama and h.flagpinjam='Y'
                         and kodeinv='".$in{"kodeinv$i"}."' and kembaliid is null rows 1 to 1 ");
                 $query->execute();
                 @row2 = $query->fetchrow_array();
                 if($xtin==1){ print("update kirimd set kembaliid='$recid', oprupdate='$s3s[0]' where recid='$row2[0]'; <br/> ");}
                 $q4 = $dba1->do("update kirimd set kembaliid='$recid', oprupdate='$s3s[0]' where recid='$row2[0]';");
                 if($q4!=0) { $qsukses++; }
             }
           }
         }
     }
     if($qsukses==$jml){ $warning = "<div class=warning_ok>Sukses Simpan Kembali Inventori dengan Nomor Surat : '$nosurat'  </div>"; $sukses=1;  }
     else
     { $dba1->do("delete from kirimd where kirimid=$recid; ");
       $dba1->do("delete from kirimh where recid=$recid; ");
       $warning = "<div class=warning_not_ok>GAGAL Simpan Kembali Inventori   </div>"; $sukses=0;
     }
  }
  else { $warning = "<div class=warning_not_ok>Gagal Header</div>"; }
 }
 
}


print qq~
<!--<script type='text/javascript' src='/jquery.min.js'></script>-->
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

  \$(function(\$) {
    var data1 = [
~;
$str="";
$query = $dba1->prepare("select kodecabang,namacabang, kodebu from getstruk order by kodecabang");
$query->execute();
while (@rec = $query->fetchrow_array())
{  $str.= qq~  { label: "$rec[0]-$rec[1]", category: "$rec[2]" },~ ;
}
$n = length($str) - 1;
$str = substr $str,0,$n;

print qq~
      $str
    ];


    \$("#cabang").catcomplete({
      delay: 0,
      source: data1
    });
  });
  </script>
~;

print qq~
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
  \$(function(\$) {
    var data2 = [
~;
$str="";
$query = $dba1->prepare("select nik,nlengkap,kodecabang from getkrynrsg order by kodecabang");
$query->execute();
while (@rec = $query->fetchrow_array())
{  $str.= qq~ { label: "$rec[0]-$rec[1]", category: "$rec[2]" },~ ;
}
$n = length($str) - 1;
$str = substr $str,0,$n;

print qq~
      $str
    ];

    \$("#currkry").catcomplete({
      delay: 0,
      source: data2
    });
  });
  </script>
~;

$from="at0012";
if($in{from}){ $from=$in{from};}

print qq~
     <table width=1000 border="0" cellspacing="0" cellpadding="0">
      <tr>
     <td align=left width=200>
     <form method=post action="/cgi-bin/sisasset.cgi" >
      <input type="submit" name="back" value="BACK" class="huruf1"/>
      <input name="pages" type="hidden" value=$from>
      <input name="ss" type="hidden" value="$in{ss}"> </form>
     </td>
     <td align=center> <h2 class="hurufcol">Kembalikan Inventori Pinjaman</h2> </td>
     <td align=right width=200>
     &nbsp;
     </td>
     ~;
   print qq~
     </tr>
     </table>

$warning
<script type='text/javascript' src='/jquery.min.js'></script>
<script type='text/javascript' src="/jquery.chained.js"></script>

<style type="text/css">\@import url("/jscalendar/calendar-blue.css");</style>
<script type="text/javascript" src="/jscalendar/calendar.js"></script>
<script type="text/javascript" src="/jscalendar/lang/calendar-en.js"></script>
<script type="text/javascript" src="/jscalendar/calendar-setup.js"></script>

<form action="/cgi-bin/sisasset.cgi" method="post" name='vq'>
<input type=hidden name=ss value="$in{ss}">
<input type=hidden name=pages value=at0013k>
<table>
<tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=100> &nbsp;Dari Cabang </td>
    <td class="hurufcol" >
   <input type=text name=cabang id=cabang value="$in{cabang}" class=huruf1 size=40 maxlength="50" style="text-transform: uppercase">
    </td>
    </tr>
<tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=100> &nbsp;Dari Karyawan </td>
    <td class="hurufcol" >
    <input type=text name=currkry id=currkry value="$in{currkry}" class=huruf1 size=40 maxlength="50" style="text-transform: uppercase">
    </td>
    </tr>

 <tr bgcolor=$colcolor height=20>
   <td class="hurufcol"> &nbsp;Tanggal Terima</td>
   <td class="hurufcol"> <input name="tgtrm" type="text" id="tgtrm" size="12" maxlength="12" class="huruf1" value="$in{tgtrm}" />
        <img src="/jscalendar/img.gif" id="trigger1" style="cursor: pointer; border: 1px solid blue;"
                title="Date selector" onMouseOver="this.style.background='blue';" onMouseOut="this.style.background=''" />
        <script type="text/javascript">
        Calendar.setup(
        {
                inputField  : "tgtrm",         // ID of the input field
                ifFormat    : "%m/%d/%Y",    // the date format
                button      : "trigger1"       // ID of the button
	       //daFormat  :  "%Y/%m/%d"
        }
        );
        </script>
</td>
</tr>

 <tr bgcolor=$colcolor height=20>
     <td class="hurufcol" width=180>&nbsp;Kepada Cabang Tujuan</td>
    <td class="hurufcol" ><select name=tujuan class="huruf1" id=tujuan>
    <option value=''>-</option>~;
$query = $dba1->prepare("select kodecabang,namacabang from getstruk where kodecabang like 'MW%' ");
$query->execute();
while (@rec = $query->fetchrow_array())
{  $selected="";
   if ($in{tujuan} eq $rec[0]) { $selected="selected";}
   print qq~<option value='$rec[0]' $selected> $rec[1]</option>~;
}
print qq~

</select>
    </td>
</tr>
 </table>

 <table>
<tr>
    <td align=center><input type='submit' name='view' value='View'> </td>
  </tr>
</table>

</form>
~;


if ($in{view} )
{

   if(!$in{currkry} and !$in{cabang}) { print "<div class=warning_not_ok>Cabang/Nama Karyawan harus di isi</div>"; }
   elsif(!$in{tgtrm}) { print "<div class=warning_not_ok>Tanggal Terima harus di isi</div>"; }
   elsif(!$in{tujuan}) { print  "<div class=warning_not_ok>Cabang Tujuan harus di isi</div>"; }
   else {


print qq ~
 $warning_del
   <FORM ACTION="/cgi-bin/sisasset.cgi" METHOD="post" name='mst'>
  <input type=hidden name=ss value="$in{ss}">
  <input type=hidden name=pages value=at0013k>
  <input name="pageid" type="hidden" value='$tmp_tgl[3]'>
  <input type=hidden name=currkry value="$in{currkry}">
  <input type=hidden name=tgtrm value="$in{tgtrm}">
  <input type=hidden name=tujuan value="$in{tujuan}">
  <input type=hidden name='action' value='delete'>
 ~;

print qq~
<script type='text/javascript' src='/jquery.min.js'></script>
<table>
<tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=100> &nbsp;Keterangan </td>
    <td class="hurufcol" >
    <input type=text name=ket value="$in{ket}" class=huruf1 size=100 maxlength="50">
    </td>
    </tr>
</table>
  <table width='1200px' border='0' cellspacing='1' cellpadding='2'>
  <tr bgcolor="$dark">
   <td align='center' class="hurufcol" width=30> No. </td>
   <td align='left' class="hurufcol" width=100> Nama Jenis </td>
   <td align='left' class="hurufcol" width=100> Kode </td>
   <td align='left' class="hurufcol" width=80> Merek </td>
   <td align='left' class="hurufcol" width=80> Tipe </td>
   <td align='left' class="hurufcol" width=80> Ukuran </td>
   <td align='left' class="hurufcol" width=50> Warna </td>
   <td align='left' class="hurufcol" width=100> Tanggal Penyerahan  </td>
   <td align='left' class="hurufcol" width=150> Kondisi</td>
   <td align='left' class="hurufcol" width=100> Keterangan</td>
   <td align='left' class="hurufcol" width=10> Chk </td>
    </tr>
~;

if  ($in{currkry})
{
   @kry=split(/\-/,$in{currkry});
   $nik = $kry[0];
   #print "$in{currkry} select idlama from getkry where nik='$nik'";
   $query = $dba1->prepare("select idlama, kodecabang from getkry where nik='$nik'");
   $query->execute();
   @row = $query->fetchrow_array();
   $idlama=$row[0];
   $currcabang = $row[1];
}
else { $idlama="0";}

$subq="";
if ($in{currkry}){$subq.=" and i.curridlama='$idlama'"; }

#$subq = substr $subq,5;
#if ($subq) {$subq = "where $subq ";}
@cab=split(/\-/,$in{cabang});
$in{cabang}=$cab[0];
if ($in{cabang}){$subq.=" and currcabang='$in{cabang}'"; }

$q = $dba1->prepare("
select namaklp,j.namajenis,i.kode,m.namamerek,t.tipe,u.namaukuran,w.namawarna,i.dtlastkirim,
i.kondisi,i.keterangan, i.currcabang,i.kondisi,i.keterangan from inventori i
left outer join jenisinv j on i.jenis=j.jenis
left outer join merek m on i.merek=m.merek
left outer join tipeinv t on i.tipe=t.tipe
left outer join ukuraninv u on i.ukuran=u.ukuran
left outer join warna w on w.warna=i.warna
join klpjenisinv k on j.klpjenis=k.klpjenis
where  i.flagpinjam='Y' $subq
order by namaklp, j.namajenis
");
$q->execute();
$no=1;
$tmpkat = '';
while (@row = $q->fetchrow_array())
{ $trm="";
  if($row[7]) { $trm = genfuncast::mdytodmy($row[7]); }
  
  if($tmpkat ne $row[0])
  { print qq~  <tr bgcolor=$colcolor2 height=20>
     <td class="hurufcol" valign="top" colspan=11><b>$row[0]</b></td>
    </tr> ~;
  }
  print qq~
  <tr bgcolor=$colcolor height=20>
     <td align='center' class="hurufcol" valign="top">$no </td>
     <td class="hurufcol" valign="top">$row[1]</td>
     <td class="hurufcol" valign="top">$row[2]</td>
     <td class="hurufcol" valign="top">$row[3]</td>
     <td class="hurufcol" valign="top">$row[4]</td>
     <td class="hurufcol" valign="top">$row[5]</td>
     <td class="hurufcol" valign="top">$row[6]</td>
     <td class="hurufcol" valign="top">$trm  </td>
     <td align='left' class="hurufcol" valign="top">~;
        for ($i=0; $i<@kondisi; $i++)
        { $checked="";
          if ($row[8] eq  $kondisi[$i]) { $checked="checked";}
         print qq~<input type=radio name=kondisi$no value='$kondisi[$i]' class=huruf1 $checked> $kondisitext[$i] &nbsp;  ~;
        }
        print qq~
      </td>
     <td align='left' class="hurufcol" valign="top"><input type=text name=keterangan$no value='$in{keterangan}' class=huruf1 maxlength="30"></td>
     <td align='left' class="hurufcol" valign="top">~;
     print qq~<input type=checkbox name=kodeinv$no value='$row[2]'> ~;
     print qq~
     <input type=hidden name=kondisiasal$no value='$row[11]'>
     <input type=hidden name=ketasal$no value='$row[12]'>
     </td>
     </tr>
  ~;
  $no++;
  $tmpkat=$row[0];
 }
$no--;
print qq ~</table>

<input type=hidden name=idlama value='$idlama'>
<input type=hidden name=cabangasal value='$currcabang'>
<input type=hidden name="baris" value='$no'>
<input type=submit value='Simpan' name="simpan" class="huruf1">

~;
print qq ~</form>~;
 }
print qq ~
    <hr width="100" />
</center>
~;
}
}

;
1

