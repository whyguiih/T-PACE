using System.Configuration;
using System.Data;
using System.Windows;

namespace T_PACE
{
    /// <summary>
    /// Interaction logic for App.xaml
    /// </summary>
    public partial class App : Application
    {
        protected override void OnStartup(StartupEventArgs e)
        {
            base.OnStartup(e);

            // Garantir que o banco exista antes do login
            try
            {
                DatabaseConfig.InicializarBanco();
            }
            catch (System.Exception ex)
            {
                MessageBox.Show($"Erro ao inicializar banco: {ex.Message}", "Erro", MessageBoxButton.OK, MessageBoxImage.Error);
                Shutdown();
                return;
            }

            var login = new LoginWindow();
            bool? ok = login.ShowDialog();

            if (ok == true)
            {
                var main = new MainWindow();
                main.Show();
            }
            else
            {
                Shutdown();
            }
        }
    }

}
