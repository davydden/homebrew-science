class Scalapack < Formula
  desc "library of high-performance linear algebra routines for parallel distributed memory machines"
  homepage "http://www.netlib.org/scalapack/"
  url "http://www.netlib.org/scalapack/scalapack-2.0.2.tgz"
  sha256 "0c74aeae690fe5ee4db7926f49c5d0bb69ce09eea75beb915e00bba07530395c"
  head "https://icl.cs.utk.edu/svn/scalapack-dev/scalapack/trunk", :using => :svn
  revision 3

  bottle do
    cellar :any
    revision 1
    sha256 "80fd977c7637d131e186dc4a016416df1c00d4736cce881631b242c990adc4bd" => :yosemite
    sha256 "fb9b8db4347d67cc9f3bd9277a7b7026c1f03453e1f28afbf8af96ea96e4f117" => :mavericks
    sha256 "e0b122d96b125fa524023dc730564b9a45ddc134b1e025c464a4c8f1a7554dcd" => :mountain_lion
  end

  option "without-check", "Skip build-time tests (not recommended)"

  depends_on :mpi => [:cc, :f90]
  depends_on "cmake" => :build
  depends_on :blas
  # depends_on "veclibfort" if build.without?("openblas") && OS.mac? ## TODO: add inside :blas
  depends_on :fortran

  def install
    args = std_cmake_args
    args << "-DBUILD_SHARED_LIBS=ON"
    ldflags = BlasRequirement.ldflags(ENV["HOMEBREW_BLASLAPACK_LIB"],ENV["HOMEBREW_BLASLAPACK_NAMES"])
    args += ["-DBLAS_LIBRARIES=#{ldflags}", "-DLAPACK_LIBRARIES=#{ldflags}"]

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "all"
      system "make", "test" if build.with? "check"
      system "make", "install"
    end
  end
end
