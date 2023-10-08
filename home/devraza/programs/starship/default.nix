{
  programs.starship = {
    enable = true;
    enableTransience = true;
    settings = {
      add_newline = true;
      character = {
        success_symbol = "λ";
        error_symbol = "λ";
      };
      hostname = {
        ssh_only = false;
        format = "[$hostname](bold purple) ";
        disabled = false;
      };
      directory.style = "bold white";
    };
  };
}
