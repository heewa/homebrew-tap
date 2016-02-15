class Bento < Formula
  desc "Simple service manager"
  homepage "https://github.com/heewa/bento"
  url "git@github.com:heewa/bento", :using => :git, :tag => "v0.1.0-alpha.1"
  sha256 "70024a6f3122e14fd66c10ad0fe4cd05e0d437f7"


  depends_on "go" => :build
  depends_on "glide" => :build

  def install
    # Copy the project to a valid gopath
    sources = `ls`.split("\n")
    (buildpath + "src/github.com/heewa/bento").install *sources

    ENV["GOPATH"] = buildpath
    ENV["GO15VENDOREXPERIMENT"] = "1"

    cd "src/github.com/heewa/bento" do
      # Install dependencies
      system "glide", "install"

      system "go", "build", "-o", "bento", "main.go"
      bin.install "bento"
    end
  end

  test do
    system "#{bin}/bento", "help"
  end
end
