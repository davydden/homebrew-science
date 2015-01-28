class Opium < Formula
  homepage "http://opium.sourceforge.net"
  url "https://downloads.sourceforge.net/project/opium/opium/opium-v3.8/opium-v3.8-src.tgz"
  sha256 "edee6606519330aecaee436ee8cfb0a33788b5677861d59e38aba936e87d5ad3"

  depends_on :fortran
  depends_on "veclibfort"
  depends_on "numdiff"

  patch :DATA

  def install
    system "./configure", "LDFLAGS=-lveclibfort"
    cd "src"
    system "make", "all-subdirs"
    system "make", "opium"
    cd ".."
    bin.install "opium"
    (share/"opium-testdir").install Dir["testdir/*"]
  end

  def caveats; <<-EOS
    Example input and output files are located in #{share}/opium-testdir
    For a discussion on failing test fe.cpi and pt.cpi see
    https://sourceforge.net/p/opium/mailman/message/33287478/
    EOS
  end

  # TODO: increase execution time, otherwise tests fail at the very end or greping
  test do
    cd "#{share}/opium-testdir"
    system "./run"
    system "./comp", "cpi"
    ohai `grep "differs from" "OUT"`.chomp
    system "./clean"
  end
end

__END__
diff --git a/src/Makefile b/src/Makefile
index 09b3356..5b2afe6 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -2,7 +2,7 @@ SHELL=/bin/sh
 
 include ../makevars
 
-subdirs=main atom pseudo output plot FlexiLib uniPPlib lapack
+subdirs=main atom pseudo output plot FlexiLib uniPPlib
 
 .PHONEY=all-subdirs
 
diff --git a/testdir/comp b/testdir/comp
index bca6349..ec5c373 100755
--- a/testdir/comp
+++ b/testdir/comp
@@ -2,6 +2,5 @@
 
 rm OUT
 foreach i (`cat LIST`)
-	echo $i >>OUT	
-	diff -ub gfortran/"$i"."$1" ifort/"$i"."$1">>OUT
+    numdiff --relative-tolerance=1e-5 --brief --minimal --essential "$i"."$1" results/"$i"."$1" >>OUT
 end
diff --git a/testdir/run b/testdir/run
index 9e83104..dec76ab 100755
--- a/testdir/run
+++ b/testdir/run
@@ -1,6 +1,6 @@
 #!/bin/csh -f
 cp params/*.param .
 foreach i (`cat LIST|egrep -v \#`)
-        echo $i
-	../opium $i $i.log ae ps nl ke tc pwf recpot fhi cpmd ncpp champ psf recpot tet upf qso rpt
+    echo $i
+    opium $i $i.log ae ps nl ke tc pwf recpot fhi cpmd ncpp champ psf recpot tet upf qso rpt
 end
