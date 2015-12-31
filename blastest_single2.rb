require_relative "blas_requirement"

class BlastestSingle2 < Formula
  desc "blas test for veclibfort (single Fortran BLAS)"
  homepage "https://github.com/davydden"
  url "https://gist.githubusercontent.com/davydden/1f9ebf3692beca2438f8/raw/0ba39c8775db3bb21c09c3440bf78ff5f778277d/blas.f90"
  version "1.0"
  sha256 "9fad00d1d7e8d5d0be3c16fd25755c5d089205fae9dd4716481f8072a6a7f954"

  depends_on :fortran
  depends_on BlasRequirement => :fortran

  def install
    ldflags    = BlasRequirement.ldflags(ENV["HOMEBREW_BLASLAPACK_LIB"], ENV["HOMEBREW_BLASLAPACK_NAMES"])
    ldflags   += " -pthread -lm"
    cflags     = BlasRequirement.cflags(ENV["HOMEBREW_BLASLAPACK_INC"])
    to_run = "#{ENV.fc} blas.f90 #{cflags} -o blastest_single #{ldflags}"
    system to_run
    bin.install "blastest_single"
  end

  test do
    system bin/"blastest_single"
  end
end
