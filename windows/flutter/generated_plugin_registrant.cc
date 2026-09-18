//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <flutter_desktop_notifications/windows_notification_plugin_c_api.h>
#include <flutter_secure_storage_windows/flutter_secure_storage_windows_plugin.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  WindowsNotificationPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("WindowsNotificationPluginCApi"));
  FlutterSecureStorageWindowsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FlutterSecureStorageWindowsPlugin"));
}
