class GlideBrew < Formula
  desc "Convert Go deps managed by glide to Homebrew resources"
  homepage "https://github.com/heewa/glide-brew"
  url "git@github.com:heewa/glide-brew", :using => :git, :revision => "v0.1.1"
  version "0.1.1"

  depends_on "glide"

  depends_on "go" => :build

  go_resource "github.com/codegangsta/cli" do
    url "https://github.com/codegangsta/cli", :using => :git, :revision => "71f57d300dd6a780ac1856c005c4b518cfd498ec"
  end

  go_resource "github.com/Masterminds/glide" do
    url "https://github.com/Masterminds/glide", :using => :git, :revision => "22afecf135d9e686b2e0872ad34f03756552905d"
  end

  go_resource "github.com/Masterminds/semver" do
    url "https://github.com/Masterminds/semver", :using => :git, :revision => "808ed7761c233af2de3f9729a041d68c62527f3a"
  end

  go_resource "github.com/Masterminds/vcs" do
    url "https://github.com/Masterminds/vcs", :using => :git, :revision => "7af28b64c5ec41b1558f5514fd938379822c237c"
  end

  go_resource "gopkg.in/yaml.v2" do
    url "https://gopkg.in/yaml.v2", :using => :git, :revision => "a83829b6f1293c91addabc89d0571c246397bbf4"
  end

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/heewa/"
    ln_s buildpath, buildpath/"src/github.com/heewa/glide-brew"
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-o", "glide-brew"
    bin.install "glide-brew"
  end

  test do
    # Init a glide project, and try to convert it into homebrew resources
    mkdir testpath/"src"
    ENV.prepend_create_path "GOPATH", testpath

    system "glide", "init"
    system "glide", "get", "github.com/Masterminds/semver"

    res = pipe_output("glide brew")
    assert_match %r{^go_resource \"github.com\/Masterminds\/semver\" do$}, res
  end
end
