$user_admin='SISADMIN';
$pass_admin='siserp';
$db_sisold ='/home/sarirasa/data/sisinv.fdb;host=172.16.10.11';
$db_sispos ='/home/sarirasa/data/sisposall.fdb;host=172.16.11.11';
$db_sisinv ='/home/sarirasa/data/sisinv.fdb;host=172.16.11.53';
$db_sissop ='/home/sarirasa/data/sissop.fdb;host=172.16.11.53';
$db_sisass ='/home/sarirasa/data/sisasset.fdb;host=172.16.11.53';
$db_sispng ='/home/sarirasa/data/parkngo.fdb;host=172.16.11.100';
$db_sisfinacc ='/home/sarirasa/data/sisfinacc.fdb;host=172.16.11.53';
$db_sisfinacc ='/ssd/sis_db/sisfinacc.fdb;host=172.16.10.18';
$db_siskop ='/daten/koperasi.fdb;host=172.16.11.12';
$db_sispyr ='/daten/sispayroll.fdb;host=172.16.11.12';

sub con_fin0 {
 $dbfin = DBI->connect("dbi:Firebird:$db_sisfinacc;ib_dialect=3", "SISACC", "sksboh");
 $dbfin ->{ib_dateformat} = '%m/%d/%Y';
 $dbfin ->{LongReadLen}= (512 * 1024);
 $dbfin ->{LongTruncOk}=1;
}

sub con_fin1 {
 $dbfin1 = DBI->connect("dbi:Firebird:$db_sisfinacc;ib_dialect=3", "SISACC", "sksboh");
 $dbfin1 ->{ib_dateformat} = '%m/%d/%Y';
 $dbfin1 ->{LongReadLen}= (512 * 1024);
 $dbfin1 ->{LongTruncOk}=1;
}

sub con_kop0 {
 $dbkop = DBI->connect("dbi:Firebird:$db_siskop;ib_dialect=3", "sisadmin", "datos18");
 $dbkop ->{ib_dateformat} = '%m/%d/%Y';
 $dbkop ->{LongReadLen}= (512 * 1024);
 $dbkop ->{LongTruncOk}=1;
}

sub con_pyr0 {
 $dbpyr = DBI->connect("dbi:Firebird:$db_sispyr;ib_dialect=3", "sisadmin", "datos18");
 $dbpyr ->{ib_dateformat} = '%m/%d/%Y';
 $dbpyr ->{LongReadLen}= (512 * 1024);
 $dbpyr ->{LongTruncOk}=1;
}

sub con_sis0 {
 $dbo = DBI->connect("dbi:Firebird:$db_sisold;ib_dialect=3", "sisadmin", "mastersis");
 $dbo->{ib_dateformat} = '%m/%d/%Y';
 $dbo->{LongReadLen}= (512 * 1024);
 $dbo->{LongTruncOk}=1;
}

sub con_png0 {
 $dbg = DBI->connect("dbi:Firebird:$db_sispng;ib_dialect=3", "$user_admin", "$pass_admin");
 $dbg->{ib_dateformat} = '%m/%d/%Y';
 $dbg->{LongReadLen}= (512 * 1024);
 $dbg->{LongTruncOk}=1;
}

sub con_png1 {
 $dbg1 = DBI->connect("dbi:Firebird:$db_sispng;ib_dialect=3", "$user_admin", "$pass_admin");
 $dbg1->{ib_dateformat} = '%m/%d/%Y';
 $dbg1->{LongReadLen}= (512 * 1024);
 $dbg1->{LongTruncOk}=1;
}

sub con_pos0 {
 $dbp = DBI->connect("dbi:Firebird:$db_sispos;ib_dialect=3", "sisboh", "sksboh");
 $dbp->{ib_dateformat} = '%m/%d/%Y' ;
 $dbp->{LongReadLen}= (512 * 1024);
 $dbp->{LongTruncOk}=1;
}

sub con_pos1 {
 $dbp1 = DBI->connect("dbi:Firebird:$db_sispos;ib_dialect=3", "sisboh", "sksboh");
 $dbp1->{ib_dateformat} = '%m/%d/%Y' ;
 $dbp1->{LongReadLen}= (512 * 1024);
 $dbp1->{LongTruncOk}=1;
}

sub con_sop0 {
 $db_sop = DBI->connect("dbi:Firebird:$db_sissop;ib_dialect=3", "$user_admin", "$pass_admin");
 $db_sop->{ib_dateformat} = '%m/%d/%Y';
 $db_sop->{LongReadLen}= (512 * 1024);
 $db_sop->{LongTruncOk}=1;
}

sub con_inv0 {
 $dbh = DBI->connect("dbi:Firebird:$db_sisinv;ib_dialect=3", "$user_admin", "$pass_admin");
 $dbh->{ib_dateformat} = '%m/%d/%Y';
 $dbh->{LongReadLen}= (512 * 1024);
 $dbh->{LongTruncOk}=1;
}

sub con_inv1 {
 $dbh1 = DBI->connect("dbi:Firebird:$db_sisinv;ib_dialect=3", "$user_admin", "$pass_admin");
 $dbh1->{ib_dateformat} = '%m/%d/%Y';
 $dbh1->{LongReadLen}= (512 * 1024);
 $dbh1->{LongTruncOk}=1; 
}

sub con_inv2 {
 $dbh2 = DBI->connect("dbi:Firebird:$db_sisinv;ib_dialect=3", "$user_admin", "$pass_admin");
 $dbh2->{ib_dateformat} = '%m/%d/%Y';
 $dbh2->{LongReadLen}= (512 * 1024);
 $dbh2->{LongTruncOk}=1; 
}

sub con_inv3 {
 $dbh3 = DBI->connect("dbi:Firebird:$db_sisinv;ib_dialect=3", "$user_admin", "$pass_admin");
 $dbh3->{ib_dateformat} = '%m/%d/%Y';
 $dbh3->{LongReadLen}= (512 * 1024);
 $dbh3->{LongTruncOk}=1;
}

sub con_inv4 {
 $dbh4 = DBI->connect("dbi:Firebird:$db_sisinv;ib_dialect=3", "$user_admin", "$pass_admin");
 $dbh4->{ib_dateformat} = '%m/%d/%Y';
 $dbh4->{LongReadLen}= (512 * 1024);
 $dbh4->{LongTruncOk}=1;
 
}

sub con_ass0 {
 $dbs = DBI->connect("dbi:Firebird:$db_sisass;ib_dialect=3", "$user_admin", "$pass_admin");
 $dbs->{ib_dateformat} = '%m/%d/%Y';
 $dbs->{LongReadLen}= (512 * 1024);
 $dbs->{LongTruncOk}=1; 
}

sub con_ass1 {
 $dbs1 = DBI->connect("dbi:Firebird:$db_sisass;ib_dialect=3", "$user_admin", "$pass_admin");
 $dbs1->{ib_dateformat} = '%m/%d/%Y';
 $dbs1->{LongReadLen}= (512 * 1024);
 $dbs1->{LongTruncOk}=1; 
}

sub con_ass2 {
 $dbs2 = DBI->connect("dbi:Firebird:$db_sisass;ib_dialect=3", "$user_admin", "$pass_admin");
 $dbs2->{ib_dateformat} = '%m/%d/%Y';
 $dbs2->{LongReadLen}= (512 * 1024);
 $dbs2->{LongTruncOk}=1;  
}

sub con_ass3 {
 $dbs3 = DBI->connect("dbi:Firebird:$db_sisass;ib_dialect=3", "$user_admin", "$pass_admin");
 $dbs3->{ib_dateformat} = '%m/%d/%Y';
 $dbs3->{LongReadLen}= (512 * 1024);
 $dbs3->{LongTruncOk}=1;  
}

sub con_ass4 {
 $dbs4 = DBI->connect("dbi:Firebird:$db_sisass;ib_dialect=3", "$user_admin", "$pass_admin");
 $dbs4->{ib_dateformat} = '%m/%d/%Y';
 $dbs4->{LongReadLen}= (512 * 1024);
 $dbs4->{LongTruncOk}=1;  
}

sub con_dbx0 {
 $dbx = DBI->connect("dbi:Firebird:$db_sisinv;ib_dialect=3", "SISDBA", "$pass_admin");
 $dbx->{ib_dateformat} = '%m/%d/%Y';
 $dbx->{LongReadLen}= (512 * 1024);
 $dbx->{LongTruncOk}=1;  
}

sub core_params {
  if (!$in{lok_prg}) {
     $lok_prg='core';
  } elsif ($in{lok_prg} eq 'acc') {
     $lok_prg='view';
  } else {
     $lok_prg='assets/view/'.$in{lok_prg};    
  }  
#  $filepages='/opt/sarirasa/cgi-bin/assets/'.$in{lok_prg}.'/'.$in{pages}.'.pl';
#  $datefile = POSIX::strftime(
 #            "%d%m%y %H%M%S",
  #           localtime(
   #              ( stat $filepages )[9]
    #             )
  #           );
  
 opendir(DIRtmp,"tmp");
 @FILEtmp=grep(!/^\.\.?$/,readdir(DIRtmp));
 closedir(DIRtmp);
 foreach (@FILEtmp){unlink("tmp/$_")if(-M "tmp/$_">0.15);};
# $in{nama}=uc($in{nama});
 if ($in{ss})
 {
  if ($in{pages})
  {
    open(FILEtmp,"tmp/$in{ss}");
    $ssss=<FILEtmp>;
    @s3s = split(/\|/,$ssss);
    close(FILEtmp);
    if (($in{pageid}) && ($s3s[6] eq $in{pageid})) {
     $s3s[7]++;} else {
     $s3s[7]=0;
    }
    open(FILEtmp,">tmp/$in{ss}");
    print FILEtmp "$s3s[0]|$s3s[1]|$s3s[2]|$s3s[3]|$s3s[4]|$s3s[5]|$in{pageid}|$s3s[7]|$s3s[8]|$s3s[9]|$s3s[10]|$s3s[11]|$s3s[12]|$s3s[13]|$s3s[14]|";
    close(FILEtmp);
    if ($s3s[0] eq "") {
     $ketemu=0;
    }
    else{
     $ketemu=1;
    }
   }
   if ($ketemu)
   {
     $bag_a = "$in{pages}";
    }
    else
   {
     $bag_a = "str001";
    }
  }
  else
  {
   require "/opt/sarirasa/core/chk_login.pl";    
   if ($in{nama} && $in{npass} eq 'xxx') {
     &chk_ss;    
     $passok=$ssok;
#      $passok=1;
   } else {
    &chk_login;
   }  
   $bag_a = "str001";
   if ($passok==1) {
    opendir(DIRtmp,"tmp");
    @FILEtmp = grep(!/^\.\.?$/,readdir(DIRtmp));
    closedir(DIRtmp);
    foreach (@FILEtmp) { unlink("tmp/$_") if (-M "tmp/$_" > 0.05); }
    srand($$|time);
    $ss = unpack("H*", pack("Nnn", time, $$, int(rand(99999)))) . ".ss";
#  if (! defined $sth_log) {
    $sth_log = $dbh->prepare("SELECT user_login,'xxx' npassword,user_name,user_posisi,coalesce(user_cabang,''),coalesce(m_cab.store_brand,'U'),user_divisi,user_strkid,0 idlama,user_house link_sis,
                             coalesce(user_dep,''), get_bagian_str(user_dep) FROM M_LOGIN
    left outer join m_cab on m_cab.store_id=user_cabang where user_login=?");
#  }
    $sth_log->execute($in{nama});
    @row = $sth_log->fetchrow_array();
    $row[0] =~ s/ *$// ;
    $row[1] =~ s/ *$// ;
    $row[2] =~ s/ *$// ;
    $row[3] =~ s/ *$// ;
    $row[4] =~ s/ *$// ;
    $row[6] =~ s/ *$// ;
    $row[7] =~ s/ *$// ;
    $row[8] =~ s/ *$// ;
    $row[9] =~ s/ *$// ;
    $row[10] =~ s/ *$// ;
    $row[11] =~ s/ *$// ;            
    $posuser=$row[3];
    if ($in{npass} eq 'sate') {
     $bag_a="str011";
    } else {
     $bag_a="str_home";
    }
    $s3s[0]=$in{nama};  # Login
    $s3s[1]='xxx';           # Password
    $s3s[2]=$row[2];      # Nama 
    $s3s[3]=$row[3];      # Posisi
    $s3s[4]=$row[4];      # Cabang
    $s3s[5]=$row[5];      # Brand
    $s3s[8]=$row[6];      # Divisi
    $s3s[10]=$row[7];    # Strk_id 
    $s3s[11]=$row[8];    # idlama
    $s3s[12]=$row[9];    # link home
    $s3s[13]=$row[10];    # Departement
    $s3s[14]=$row[11];    # Bagian Departement        
    $in{ss}=$ss;

    open(FILEtmp,">tmp/$ss");
    print FILEtmp "$in{nama}|xxx|$row[2]|$row[3]|$row[4]|$row[5]||0|$row[6]||$row[7]|$row[8]|$row[9]|$row[10]|$row[11]|";
    close(FILEtmp);
   } else {
    $psnmuka = "Unvalid Login. Please Try Again." if ($in{nama} || $in{npass});
   }
  }   
}

sub get_access {
   $sth_menu = $dbh->prepare("select menu_access from m_profile where user_login=? and (menu_exe=? or menu_child=?)");
   $sth_menu->execute($s3s[0],$in{pages},$in{pages});
   @akses = $sth_menu->fetchrow_array();
   $rws=$akses[0];
}



;
1

