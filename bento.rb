class Bento < Formula
  desc "Simple service manager"
  homepage "https://github.com/heewa/bento"
  url "git@github.com:heewa/bento", :using => :git, :tag => "v0.1.0-alpha.1", :revision => "70024a6f3122e14fd66c10ad0fe4cd05e0d437f7"
  version "0.1.0-alpha.1"
  # TODO: when switching to tarball (public repo), list sha256

  option "without-man-page", "Skip installing man page"

  devel do
    url "git@github.com:heewa/bento", :using => :git, :revision => "9301dc012d8a515e00981525f2f49d1714c7346c"
    version "0.1.0-alpha.1.1"
    # TODO: when switching to tarball (public repo), list sha256
  end

  depends_on "go" => :build
  depends_on "glide" => :build

  def install
    # Copy the project to a valid gopath
    (buildpath/"src/github.com/heewa/bento").install Dir["*"]

    ENV["GOPATH"] = buildpath
    ENV["GO15VENDOREXPERIMENT"] = "1"

    cd "src/github.com/heewa/bento" do
      # Install dependencies. TODO: make these homebrew resources
      system "glide", "install"

      # TODO: How do I specifically use the brew-installed go binary? It matters :/
      system "go", "build", "-v", "-o", "bento", "main.go"

      if build.with? "man-page"
        system "./bento --help-man > bento.1"
        man1.install "bento.1"
      end

      bin.install "bento"
    end
  end

  test do
    system "#{bin}/bento", "help"
  end
end
