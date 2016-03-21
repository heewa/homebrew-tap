require "language/go"

class Bento < Formula
  desc "Simple service manager"
  homepage "https://gist.github.com/heewa/8a3b8bc5eddcef5b8b84"

  stable do
    url "https://s3.amazonaws.com/heewa.bento/releases/bento-v0.1.0-alpha.2.2.tar.gz"
    version "0.1.0-alpha.2.2"
    sha256 "8a5d9189206041847d32056d6ed3be03a3369996353c72ba170e455afc11fb0c"

    # Go deps, generated from `glide brew`

    go_resource "github.com/alecthomas/template" do
      url "https://github.com/alecthomas/template", :using => :git, :revision => "14fd436dd20c3cc65242a9f396b61bfc8a3926fc"
    end

    go_resource "github.com/alecthomas/units" do
      url "https://github.com/alecthomas/units", :using => :git, :revision => "2efee857e7cfd4f3d0138cc3cbb1b4966962b93a"
    end

    go_resource "github.com/blang/semver" do
      url "https://github.com/blang/semver", :using => :git, :revision => "aea32c919a18e5ef4537bbd283ff29594b1b0165"
    end

    go_resource "github.com/dustin/go-humanize" do
      url "https://github.com/dustin/go-humanize", :using => :git, :revision => "8929fe90cee4b2cb9deb468b51fb34eba64d1bf0"
    end

    go_resource "github.com/fatih/color" do
      url "https://github.com/fatih/color", :using => :git, :revision => "7a5857db0b2752a436d8461d88c42dea0ee191c0"
    end

    go_resource "github.com/getlantern/golog" do
      url "https://github.com/getlantern/golog", :using => :git, :revision => "157ff085527fe90d386163e8d3ca6c180ba5e26c"
    end

    go_resource "github.com/getlantern/systray" do
      url "https://github.com/getlantern/systray", :using => :git, :revision => "2bd673783db47a90635d96fda462d2614ccb1a24"
    end

    go_resource "github.com/inconshreveable/log15" do
      url "https://github.com/inconshreveable/log15", :using => :git, :revision => "210d6fdc4d979ef6579778f1b6ed84571454abb4"
    end

    go_resource "github.com/mattn/go-colorable" do
      url "https://github.com/mattn/go-colorable", :using => :git, :revision => "9fdad7c47650b7d2e1da50644c1f4ba7f172f252"
    end

    go_resource "github.com/mattn/go-isatty" do
      url "https://github.com/mattn/go-isatty", :using => :git, :revision => "56b76bdf51f7708750eac80fa38b952bb9f32639"
    end

    go_resource "github.com/skratchdot/open-golang" do
      url "https://github.com/skratchdot/open-golang", :using => :git, :revision => "c8748311a7528d0ba7330d302adbc5a677ef9c9e"
    end

    go_resource "gopkg.in/alecthomas/kingpin.v2" do
      url "https://github.com/heewa/kingpin", :using => :git, :revision => "21652f8b369143c3332b41bfbdc3dc878102feec"
    end

    go_resource "gopkg.in/yaml.v2" do
      url "https://gopkg.in/yaml.v2", :using => :git, :revision => "f7716cbe52baa25d2e9b0d0da546fcf909fc16b4"
    end
  end

  devel do
    url "git@github.com:heewa/bento", :using => :git, :revision => "v0.1.0-alpha.2.2"
    version "0.1.0-alpha.2.2"

    depends_on "glide" => :build
  end

  option "without-man-page", "Skip installing man page"
  option "without-bash-complete", "Skip installing bash autocomplete support"

  depends_on "go" => :build

  def install
    # Copy the project to a valid gopath
    bento_path = buildpath/"src/github.com/heewa/bento"
    bento_path.install Dir["*"]

    ENV["GOPATH"] = buildpath

    if build.stable?
      Language::Go.stage_deps resources, buildpath/"src"
    end

    cd bento_path do
      if !build.stable?
        ohai "Getting go dependencies"

        ENV["GO15VENDOREXPERIMENT"] = "1"
        system "glide", "install"
      end

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
