class Bento < Formula
  desc "Simple service manager"
  homepage "https://gist.github.com/heewa/8a3b8bc5eddcef5b8b84"
  url "https://s3.amazonaws.com/heewa.bento/releases/bento-v0.1.0-alpha.2.tar.gz"
  version "0.1.0-alpha.2"
  sha256 "28ad29b8f1bb59d26880c8a6f974b2589562526aee5ae0f0531076592ad92402"

  option "without-man-page", "Skip installing man page"
  option "without-bash-complete", "Skip installing bash autocomplete support"

  devel do
    url "git@github.com:heewa/bento", :using => :git, :revision => "0413ea618de286e5f627ae642303ae658418d655"
    version "0.1.0-alpha.2"
    sha256 "28ad29b8f1bb59d26880c8a6f974b2589562526aee5ae0f0531076592ad92402"
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

      if build.with? "bash-complete"
        system "./bento --completion-script-bash > bento_completion.bash"
        bash_completion.install "bento_completion.bash"
      end

      bin.install "bento"
    end
  end

  test do
    system "#{bin}/bento", "help"
  end
end
