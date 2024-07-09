{ pkgs, ... }:
{
  virtualisation.oci-containers.containers = {
    "redlib" = {
      image = "quay.io/redlib/redlib:latest";
      ports = [ "127.0.0.1:9080:8080" ];
      environment = {
        REDLIB_SFW_ONLY = "off";
        REDLIB_BANNER = "High coverage obtained!";
        REDLIB_ROBOTS_DISABLE_INDEXING = "on";
        REDLIB_PUSHSHIFT_FRONTEND = "undelete.pullpush.io";
        REDLIB_DEFAULT_THEME = "system";
        REDLIB_DEFAULT_FRONT_PAGE = "default";
        REDLIB_DEFAULT_LAYOUT = "card";
        REDLIB_DEFAULT_WIDE = "off";
        REDLIB_DEFAULT_POST_SORT = "hot";
        REDLIB_DEFAULT_COMMENT_SORT = "top";
        REDLIB_DEFAULT_SHOW_NSFW = "on";
        REDLIB_DEFAULT_BLUR_NSFW = "off";
        REDLIB_DEFAULT_USE_HLS = "on";
        REDLIB_DEFAULT_HIDE_HLS_NOTIFICATION = "off";
        REDLIB_DEFAULT_AUTOPLAY_VIDEOS = "off";
        REDLIB_DEFAULT_SUBSCRIPTIONS = "selfhosted+homelab+programmerhumor";
        REDLIB_DEFAULT_HIDE_AWARDS = "on";
        REDLIB_DEFAULT_HIDE_SIDEBAR_AND_SUMMARY = "off";
        REDLIB_DEFAULT_DISABLE_VISIT_REDDIT_CONFIRMATION = "off";
        REDLIB_DEFAULT_HIDE_SCORE = "off";
        REDLIB_DEFAULT_FIXED_NAVBAR = "on";
      };
      extraOptions = [ "--pull=newer" "--dns=9.9.9.9" ];
    };
  };
}
