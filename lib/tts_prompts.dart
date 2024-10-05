// lib/tts_prompts.dart

class TtsPrompts {
  static final Map<String, Map<String, String>> prompts = {
    'en-US': {
      // Calculator Prompts
      'result_computed': 'The result is {result}.',
      'calculation_error': 'There was an error in your calculation.',
      'language_changed': 'Language changed to {langName}.',
      'button_pressed': 'Button {button} pressed.',
      'clear': 'Calculation cleared.',
      'multiply': 'Multiply.',
      'divide': 'Divide.',
      'equals': 'Equals.',
      
      // Communication Page Prompts
      'no_image_selected': 'No image selected.',
      'error_picking_image': 'Error picking image.',
      'error_processing_image': 'Error processing image.',
      'no_text_recognized': 'No text recognized in the image.',
      'please_help_me': 'Please help me.',
      'add_new_phrase': 'Add New Phrase.',
      'add_phrase_success': 'Phrase added successfully.',
      'add_phrase_error': 'Please enter a phrase and select an image.',
      'remove_phrase': 'Phrase removed successfully.',
      'cannot_delete_predefined': 'Cannot delete predefined phrases.',
      
      // Home Page Prompts
      'found_nearby_stores': 'Found {count} nearby stores.',
      'no_nearby_stores': 'No nearby stores found.',
      'error_fetching_stores': 'Error fetching nearby stores.',
      'language_unsupported': 'Language Unsupported.',
      'opening_gallery': 'Opening gallery.',
      'opening_camera': 'Opening camera.',
      'opening_communication_assist': 'Opening communication assist.',
      'navigating_to_calculator': 'Navigating to Calculator.',
      'navigating_to_stores': 'Navigating to Stores.',
      'error_retrieving_location': 'Error retrieving location.',
      'location_permission_denied': 'Location permission denied.',
      
      // Stores Page Prompts
      'navigating_to_menu': 'Navigating to {storeName} Menu.',
      'menu_not_available': 'Menu not available for {storeName}.',
      
      // Order Summary Prompts
      'processing_payment': 'Processing Payment...',
      'no_items_to_read': 'No items in your order to read.',
      'payment_confirmed': 'Payment assistance completed. Thank you!',
      'payment_canceled': 'Payment assistance canceled.',
      
      // Payment Assistance Prompts
      'intro_payment_assist': 'Welcome to the Payment Assistance Module. Let\'s learn how to make a payment.',
      'step1_payment_assist': 'First, you need to select the denominations that add up to your total amount of {amount}.',
      'step2_payment_assist': 'Select the denominations by tapping on them. Each time you select a denomination, it will be added to your payment.',
      'step3_payment_assist': 'The remaining amount will be updated accordingly. Continue selecting denominations until the remaining amount is zero.',
      'step4_payment_assist': 'Once you\'ve matched the total amount, press the Confirm Payment button to complete the payment.',
      'encouragement_payment_assist': 'Let\'s get started!',
      'selected_denomination': 'Selected {denomination} note.',
      'cannot_select_denomination': 'You cannot select {denomination} as it exceeds the remaining amount of {remainingAmount}.',
      'confirm_payment_success': 'Payment assistance completed. Thank you!',
      'confirm_payment_canceled': 'Payment assistance canceled.',
      'payment_assist_instructions': 'You can use the Assist Payment button to get help with your payment.',
      
      // Miscellaneous Prompts
      'no_items_selected': 'No items selected.',
      'customization_cancelled': 'Customization cancelled.',
      'navigation_success': 'Navigation successful.',
      'no_selection': 'No selection made.',
      
      // Communication Phrase Prompts
      'phrase_order_food': 'I would like to order food.',
      'phrase_menu_request': 'Can I have the menu, please?',
      'phrase_need_assistance': 'I need assistance.',
      'phrase_restroom_location': 'Where is the restroom?',
      'phrase_thank_you': 'Thank you.',
      'phrase_call_waiter': 'Please call a waiter.',
      'phrase_ready_to_pay': 'I am ready to pay.',
      'phrase_excuse_me': 'Excuse me.',
      'phrase_repeat': 'Could you repeat that?',
      'phrase_have_question': 'I have a question.',
      'phrase_hungry': 'I am hungry.',
      'phrase_thirsty': 'I am thirsty.',
      'phrase_cost_inquiry': 'How much does this cost?',
      'phrase_do_not_understand': 'I do not understand.',
      'phrase_please_help': 'Please help me.',
      'phrase_goodbye': 'Goodbye.',

      // New Order Summary Prompts
      'order_summary_intro': 'Here is your order summary.',
      'order_item': '{itemName} {customizationDescription} at {price} dollars.',
      'order_total': 'Your total amount is {total} dollars.',
      'proceed_to_confirm': 'Please proceed to confirm your order.',
      
      'speak_changes_due': 'Your change due is \${changeDue}.',

      // New Payment Assistance Prompts
      'payment_assist_no_items': 'No items in your order to assist with payment.',
      'payment_assist_payment_success': 'Payment confirmed. Thank you!',
      'payment_assist_payment_failure': 'Payment was canceled.',
      
      // Additional prompts as needed
      'item_added_no_customizations': '{itemName} added to your order without any customizations.',
      'item_added_with_customizations': '{itemName} customized with {customizations} added to your order.',
      'item_removed': '{itemName} removed from your order.',
      'payment_assist_reset': 'Payment selections have been reset. Let\'s try again.',

      // SpeechToText Prompts
      'navigating_to_speech_to_text': 'Navigating to Speech Assist page.',
      'speech_not_available': 'Speech recognition is not available.',
      'speech_error': 'An error occurred during speech recognition.',
      'speech_started': 'Listening started.',
      'speech_stopped': 'Listening stopped.',
      'no_texts_recognized': 'No text is recognized.',
      'confirm_text_success': 'Text has been confirmed.',
      'add_phrases_success': 'Phrase added successfully.',
      'remove_phrases': 'Phrase removed successfully.',
    },
    'zh-CN': {
      // Calculator Prompts
      'result_computed': '结果是 {result}。',
      'calculation_error': '您的计算有误。',
      'language_changed': '语言已更改为 {langName}。',
      'button_pressed': '按钮 {button} 已按下。',
      'clear': '计算已清除。',
      'multiply': '乘。',
      'divide': '除。',
      'equals': '等于。',
      'speak_changes_due': '您的找零是 \${changeDue}。',

      // Communication Page Prompts
      'no_image_selected': '未选择图片。',
      'error_picking_image': '选择图片时出错。',
      'error_processing_image': '处理图片时出错。',
      'no_text_recognized': '图片中未识别到文本。',
      'please_help_me': '请帮帮我。',
      'add_new_phrase': '添加新短语。',
      'add_phrase_success': '短语添加成功。',
      'add_phrase_error': '请输入一个短语并选择一张图片。',
      'remove_phrase': '短语已成功删除。',
      'cannot_delete_predefined': '无法删除预定义短语。',
      
      // Home Page Prompts
      'found_nearby_stores': '找到 {count} 家附近的商店。',
      'no_nearby_stores': '附近没有找到商店。',
      'error_fetching_stores': '获取附近商店时出错。',
      'language_unsupported': '语言不支持。',
      'opening_gallery': '正在打开图库。',
      'opening_camera': '正在打开相机。',
      'opening_communication_assist': '正在打开交流辅助。',
      'navigating_to_calculator': '正在导航到计算器。',
      'navigating_to_stores': '正在导航到商店。',
      'error_retrieving_location': '检索位置时出错。',
      'location_permission_denied': '位置权限被拒绝。',
      
      // Stores Page Prompts
      'navigating_to_menu': '正在导航到 {storeName} 菜单。',
      'menu_not_available': '无法获取 {storeName} 的菜单。',
      
      // Order Summary Prompts
      'processing_payment': '正在处理付款...',
      'no_items_to_read': '您的订单中没有项目可供阅读。',
      'payment_confirmed': '付款协助完成。谢谢！',
      'payment_canceled': '付款协助已取消。',
      
      // Payment Assistance Prompts
      'intro_payment_assist': '欢迎使用付款协助模块。让我们学习如何付款。',
      'step1_payment_assist': '首先，您需要选择金额总和为 {amount} 的面额。',
      'step2_payment_assist': '通过点击面额来选择。每次选择一个面额，它将被添加到您的付款中。',
      'step3_payment_assist': '剩余金额将相应更新。继续选择面额，直到剩余金额为零。',
      'step4_payment_assist': '一旦您匹配了总金额，请按“确认付款”按钮完成付款。',
      'encouragement_payment_assist': '让我们开始吧！',
      'selected_denomination': '已选择 {denomination} 钞票。',
      'cannot_select_denomination': '您无法选择 {denomination}，因为它超过了剩余金额 {remainingAmount}。',
      'confirm_payment_success': '付款协助完成。谢谢！',
      'confirm_payment_canceled': '付款协助已取消。',
      'payment_assist_instructions': '您可以使用“协助付款”按钮来获取付款帮助。',
      
      // Miscellaneous Prompts
      'no_items_selected': '未选择任何项目。',
      'customization_cancelled': '自定义已取消。',
      'navigation_success': '导航成功。',
      'no_selection': '未做出选择。',
      
      // Communication Phrase Prompts
      'phrase_order_food': '我想点餐。',
      'phrase_menu_request': '请给我菜单。',
      'phrase_need_assistance': '我需要帮助。',
      'phrase_restroom_location': '洗手间在哪里？',
      'phrase_thank_you': '谢谢你。',
      'phrase_call_waiter': '请叫服务员。',
      'phrase_ready_to_pay': '我准备付款了。',
      'phrase_excuse_me': '打扰一下。',
      'phrase_repeat': '您能重复一遍吗？',
      'phrase_have_question': '我有一个问题。',
      'phrase_hungry': '我饿了。',
      'phrase_thirsty': '我渴了。',
      'phrase_cost_inquiry': '这个多少钱？',
      'phrase_do_not_understand': '我不明白。',
      'phrase_please_help': '请帮帮我。',
      'phrase_goodbye': '再见。',
    
      // New Order Summary Prompts
      'order_summary_intro': '这是您的订单摘要。',
      'order_item': '{itemName} {customizationDescription}，价格为 {price} dollars。',
      'order_total': '您的总金额是 {total} dollars。',
      'proceed_to_confirm': '请继续确认您的订单。',
      
      // New Payment Assistance Prompts
      'payment_assist_no_items': '您的订单中没有项目可供付款协助。',
      'payment_assist_payment_success': '付款已确认。谢谢！',
      'payment_assist_payment_failure': '付款已取消。',
      
      // Additional prompts as needed
      'item_added_no_customizations': '已将 {itemName} 添加到您的订单，无任何自定义。',
      'item_added_with_customizations': '已将带有 {customizations} 的 {itemName} 添加到您的订单。',
      'item_removed': '已从您的订单中移除 {itemName}。',
      'payment_assist_reset': '付款选择已重置。让我们再试一次。',

      // SpeechToText Prompts
      'navigating_to_speech_to_text': '正在导航到语音辅助页面。',
      'speech_not_available': '语音识别不可用。',
      'speech_error': '语音识别过程中发生错误。',
      'speech_started': '开始聆听。',
      'speech_stopped': '停止聆听。',
      'no_texts_recognized': '未识别到文本。',
      'confirm_text_success': '文本已确认。',
      'add_phrases_success': '短语添加成功。',
      'remove_phrases': '短语已成功删除。',
    },
    'ms-MY': {
      // Calculator Prompts
      'result_computed': 'Keputusannya adalah {result}.',
      'calculation_error': 'Terdapat ralat dalam pengiraan anda.',
      'language_changed': 'Bahasa telah ditukar kepada {langName}.',
      'button_pressed': 'Butang {button} ditekan.',
      'clear': 'Pengiraan telah dibersihkan.',
      'multiply': 'Darab.',
      'divide': 'Bahagikan.',
      'equals': 'Sama dengan.',
      'speak_changes_due': 'Baki anda ialah \${changeDue}.',

      // Communication Page Prompts
      'no_image_selected': 'Tiada imej dipilih.',
      'error_picking_image': 'Ralat semasa memilih imej.',
      'error_processing_image': 'Ralat semasa memproses imej.',
      'no_text_recognized': 'Tiada teks dikenali dalam imej.',
      'please_help_me': 'Tolong bantu saya.',
      'add_new_phrase': 'Tambah Frasa Baru.',
      'add_phrase_success': 'Frasa berjaya ditambah.',
      'add_phrase_error': 'Sila masukkan frasa dan pilih imej.',
      'remove_phrase': 'Frasa berjaya dipadam.',
      'cannot_delete_predefined': 'Tidak boleh memadam frasa yang ditetapkan.',
      

      // Home Page Prompts
      'found_nearby_stores': 'Ditemui {count} kedai berdekatan.',
      'no_nearby_stores': 'Tiada kedai berdekatan dijumpai.',
      'error_fetching_stores': 'Ralat semasa memuat turun kedai berdekatan.',
      'language_unsupported': 'Bahasa Tidak Disokong.',
      'opening_gallery': 'Membuka galeri.',
      'opening_camera': 'Membuka kamera.',
      'opening_communication_assist': 'Membuka bantuan komunikasi.',
      'navigating_to_calculator': 'Mengarahkan ke Pengira.',
      'navigating_to_stores': 'Mengarahkan ke Kedai.',
      'error_retrieving_location': 'Ralat semasa mendapatkan lokasi.',
      'location_permission_denied': 'Kebenaran lokasi ditolak.',
      
      // Stores Page Prompts
      'navigating_to_menu': 'Mengarahkan ke Menu {storeName}.',
      'menu_not_available': 'Menu tidak tersedia untuk {storeName}.',
      
      // Order Summary Prompts
      'processing_payment': 'Memproses Pembayaran...',
      'no_items_to_read': 'Tiada item dalam pesanan anda untuk dibaca.',
      'payment_confirmed': 'Bantuan pembayaran selesai. Terima kasih!',
      'payment_canceled': 'Bantuan pembayaran dibatalkan.',
      
      // Payment Assistance Prompts
      'intro_payment_assist': 'Selamat datang ke Modul Bantuan Pembayaran. Mari kita pelajari cara membuat pembayaran.',
      'step1_payment_assist': 'Pertama, anda perlu memilih denominasi yang jumlahnya adalah {amount}.',
      'step2_payment_assist': 'Pilih denominasi dengan mengetiknya. Setiap kali anda memilih denominasi, ia akan ditambahkan ke pembayaran anda.',
      'step3_payment_assist': 'Jumlah baki akan dikemaskini sewajarnya. Teruskan memilih denominasi sehingga baki jumlah adalah sifar.',
      'step4_payment_assist': 'Setelah anda menyamai jumlah total, tekan butang Sahkan Pembayaran untuk melengkapkan pembayaran.',
      'encouragement_payment_assist': 'Mari kita mulakan!',
      'selected_denomination': 'Denominasi {denomination} telah dipilih.',
      'cannot_select_denomination': 'Anda tidak boleh memilih {denomination} kerana ia melebihi jumlah baki {remainingAmount}.',
      'confirm_payment_success': 'Bantuan pembayaran selesai. Terima kasih!',
      'confirm_payment_canceled': 'Bantuan pembayaran dibatalkan.',
      'payment_assist_instructions': 'Anda boleh menggunakan butang “Bantuan Pembayaran” untuk mendapatkan bantuan dengan pembayaran anda.',
      
      // Miscellaneous Prompts
      'no_items_selected': 'Tiada item dipilih.',
      'customization_cancelled': 'Pengubahsuaian dibatalkan.',
      'navigation_success': 'Navigasi berjaya.',
      'no_selection': 'Tiada pilihan dibuat.',
      
      // Communication Phrase Prompts
      'phrase_order_food': 'Saya ingin memesan makanan.',
      'phrase_menu_request': 'Bolehkah saya minta menu, sila?',
      'phrase_need_assistance': 'Saya memerlukan bantuan.',
      'phrase_restroom_location': 'Di mana tandas?',
      'phrase_thank_you': 'Terima kasih.',
      'phrase_call_waiter': 'Sila panggil pelayan.',
      'phrase_ready_to_pay': 'Saya bersedia untuk membayar.',
      'phrase_excuse_me': 'Maafkan saya.',
      'phrase_repeat': 'Bolehkah anda ulangi itu?',
      'phrase_have_question': 'Saya ada soalan.',
      'phrase_hungry': 'Saya lapar.',
      'phrase_thirsty': 'Saya dahaga.',
      'phrase_cost_inquiry': 'Ini berapa harganya?',
      'phrase_do_not_understand': 'Saya tidak faham.',
      'phrase_please_help': 'Tolong bantu saya.',
      'phrase_goodbye': 'Selamat tinggal.',
    
      // New Order Summary Prompts
      'order_summary_intro': 'Berikut adalah ringkasan pesanan anda.',
      'order_item': '{itemName} {customizationDescription} pada harga {price} dollars.',
      'order_total': 'Jumlah keseluruhan anda adalah {total} dollars.',
      'proceed_to_confirm': 'Sila teruskan untuk mengesahkan pesanan anda.',
      
      // New Payment Assistance Prompts
      'payment_assist_no_items': 'Tiada item dalam pesanan anda untuk bantuan pembayaran.',
      'payment_assist_payment_success': 'Pembayaran telah disahkan. Terima kasih!',
      'payment_assist_payment_failure': 'Pembayaran telah dibatalkan.',
      
      // Additional prompts as needed
      'item_added_no_customizations': '{itemName} ditambahkan ke pesanan anda tanpa sebarang penyesuaian.',
      'item_added_with_customizations': '{itemName} yang disesuaikan dengan {customizations} ditambahkan ke pesanan anda.',
      'item_removed': '{itemName} telah dikeluarkan dari pesanan anda.',
      'payment_assist_reset': 'Pilihan pembayaran telah direset. Mari kita cuba lagi.',

       // SpeechToText Prompts
      'navigating_to_speech_to_text': 'Menuju ke halaman Bantuan Ucapan.',
      'speech_not_available': 'Pengenalan ucapan tidak tersedia.',
      'speech_error': 'Terjadi ralat semasa pengenalan ucapan.',
      'speech_started': 'Mula mendengar.',
      'speech_stopped': 'Berhenti mendengar.',
      'no_texts_recognized': 'Tiada teks dikenali.',
      'confirm_text_success': 'Teks telah disahkan.',
      'add_phrases_success': 'Frasa berjaya ditambah.',
      'remove_phrases': 'Frasa berjaya dipadam.',
    },
    'ta-IN': {
      // Calculator Prompts
      'result_computed': 'முடிவு {result}.',
      'calculation_error': 'உங்கள் கணக்கில் பிழை ஏற்பட்டது.',
      'language_changed': 'மொழி {langName} இல் மாற்றப்பட்டது.',
      'button_pressed': 'பொத்தானை {button} அழுத்தப்பட்டது.',
      'clear': 'கணக்கை அழித்துவிட்டோம்.',
      'multiply': 'பெருக்கவும்.',
      'divide': 'வகுக்கவும்.',
      'equals': 'சமம்.',
      
      // Communication Page Prompts
      'no_image_selected': 'படம் தேர்ந்தெடுக்கப்படவில்லை.',
      'error_picking_image': 'படத்தை தேர்ந்தெடுக்கும்போது பிழை ஏற்பட்டது.',
      'error_processing_image': 'படத்தை செயலாக்கும்போது பிழை ஏற்பட்டது.',
      'no_text_recognized': 'படத்தில் உரை அடையாளம் காணப்படவில்லை.',
      'please_help_me': 'தயவு செய்து எனக்கு உதவி செய்யவும்.',
      'add_new_phrase': 'புதிய சொற்றொடரைச் சேர்க்கவும்.',
      'add_phrase_success': 'சொற்றொடர் வெற்றிகரமாக சேர்க்கப்பட்டது.',
      'add_phrase_error': 'தயவு செய்து ஒரு சொற்றொடரைச் சேர்க்கவும் மற்றும் ஒரு படத்தைத் தேர்ந்தெடுக்கவும்.',
      'remove_phrase': 'சொற்றொடர் வெற்றிகரமாக அகற்றப்பட்டது.',
      'cannot_delete_predefined': 'முன்பதிவுசெய்யப்பட்ட சொற்றொடர்களை நீக்க முடியாது.',
      'speak_changes_due': 'உங்கள் மீதமுள்ள எண் \${changeDue}.',
      // Home Page Prompts
      'found_nearby_stores': 'அருகிலுள்ள கடைகள் {count} கிடைத்தன.',
      'no_nearby_stores': 'அருகிலுள்ள கடைகள் எதுவும் கிடைக்கவில்லை.',
      'error_fetching_stores': 'அருகிலுள்ள கடைகளைப் பெறும்போது பிழை ஏற்பட்டது.',
      'language_unsupported': 'மொழி ஆதரிக்கப்படவில்லை.',
      'opening_gallery': 'கேலரியை திறக்கிறது.',
      'opening_camera': 'கேமராவை திறக்கிறது.',
      'opening_communication_assist': 'தொடர்பு உதவியை திறக்கிறது.',
      'navigating_to_calculator': 'கணக்கியில் வழிசெலுத்துகிறது.',
      'navigating_to_stores': 'கடைகளுக்கு வழிசெலுத்துகிறது.',
      'error_retrieving_location': 'இடத்தைப் பெறும்போது பிழை ஏற்பட்டது.',
      'location_permission_denied': 'இட அனுமதியை நிராகரிக்கப்பட்டது.',
      
      // Stores Page Prompts
      'navigating_to_menu': '{storeName} மெனுவுக்கு வழிசெலுத்துகிறது.',
      'menu_not_available': '{storeName} க்கான மெனு கிடைக்கவில்லை.',
      
      // Order Summary Prompts
      'processing_payment': 'செலுத்தும் பணியை செயலாக்குகிறது...',
      'no_items_to_read': 'உங்கள் ஆர்டரில் வாசிக்க பொருட்கள் இல்லை.',
      'payment_confirmed': 'செலுத்தும் உதவி முடிந்தது. நன்றி!',
      'payment_canceled': 'செலுத்தும் உதவி ரத்து செய்யப்பட்டது.',
      
      // Payment Assistance Prompts
      'intro_payment_assist': 'செலுத்தும் உதவி மாட்யூலுக்கு வரவேற்கிறோம். செலுத்தும் முறையை கற்றுக்கொள்ளுவோம்.',
      'step1_payment_assist': 'முதலில், உங்கள் மொத்த தொகை {amount} ஆகும் நோட்டுகள் தேர்ந்தெடுக்க வேண்டும்.',
      'step2_payment_assist': 'நோட்டுகளை தொட்டு தேர்ந்தெடுக்கவும். ஒவ்வொரு முறையும் நீங்கள் ஒரு நோட்டை தேர்ந்தெடுக்கும் போதெல்லாம் அது உங்கள் செலுத்தலுக்கு சேர்க்கப்படும்.',
      'step3_payment_assist': 'மீதமுள்ள தொகை அதற்கேற்ப புதுப்பிக்கப்படும். மீதமுள்ள தொகை பூஜ்ஜியம் வரை நோட்டுகளை தேர்ந்தெடுக்கத் தொடரவும்.',
      'step4_payment_assist': 'மொத்த தொகையை ஒப்பிட்டு முடித்தவுடன், "செலுத்தலை உறுதி செய்" பொத்தானை அழுத்தி செலுத்தலை முடிக்கவும்.',
      'encouragement_payment_assist': 'ஆரம்பிப்போம்!',
      'selected_denomination': '{denomination} நோட்டை தேர்ந்தெடுக்கப்பட்டது.',
      'cannot_select_denomination': '{denomination} தேர்ந்தெடுக்க முடியாது, அது மீதமுள்ள தொகை {remainingAmount} ஐ மீறுகிறது.',
      'confirm_payment_success': 'செலுத்தும் உதவி முடிந்தது. நன்றி!',
      'confirm_payment_canceled': 'செலுத்தும் உதவி ரத்து செய்யப்பட்டது.',
      'payment_assist_instructions': 'பணம் செலுத்த உதவ “Bantuan Pembayaran” பொத்தானை பயன்படுத்தலாம்.',
      
      // Miscellaneous Prompts
      'no_items_selected': 'பொருட்கள் தேர்ந்தெடுக்கப்படவில்லை.',
      'customization_cancelled': 'Pengubahsuaian dibatalkan.',
      'navigation_success': 'Navigasi berjaya.',
      'no_selection': 'Tiada pilihan dibuat.',
      
      // Communication Phrase Prompts
      'phrase_order_food': 'நான் உணவு ஆர்டர் செய்ய விரும்புகிறேன்.',
      'phrase_menu_request': 'மெனு தர முடியுமா, தயவு செய்து?',
      'phrase_need_assistance': 'எனக்கு உதவி தேவை.',
      'phrase_restroom_location': 'சுத்திகரிப்பறை எங்கே?',
      'phrase_thank_you': 'நன்றி.',
      'phrase_call_waiter': 'சேவையாளர் அழைக்கவும்.',
      'phrase_ready_to_pay': 'நான் பணம் செலுத்த தயாராக இருக்கிறேன்.',
      'phrase_excuse_me': 'மன்னிக்கவும்.',
      'phrase_repeat': 'நீங்கள் மீண்டும் சொல்ல முடியுமா?',
      'phrase_have_question': 'எனக்கு ஒரு கேள்வி உள்ளது.',
      'phrase_hungry': 'எனக்கு பசி அடைந்தது.',
      'phrase_thirsty': 'எனக்கு தாகம் வந்தது.',
      'phrase_cost_inquiry': 'இது எவ்வளவு செல்கிறது?',
      'phrase_do_not_understand': 'நான் புரியவில்லை.',
      'phrase_please_help': 'தயவு செய்து எனக்கு உதவி செய்யவும்.',
      'phrase_goodbye': 'வணக்கம்.',
    
      // New Order Summary Prompts
      'order_summary_intro': 'இது உங்கள் ஆர்டரின் சுருக்கம்.',
      'order_item': '{itemName} {customizationDescription} இல் {price} dollars ஆகும்.',
      'order_total': 'உங்கள் மொத்த தொகை {total} dollars.',
      'proceed_to_confirm': 'உங்கள் ஆர்டரை உறுதிப்படுத்த தொடரவும்.',
      
      // New Payment Assistance Prompts
      'payment_assist_no_items': 'உங்கள் ஆர்டரில் பணம் செலுத்த உதவி செய்ய எந்தப் பொருட்களும் இல்லை.',
      'payment_assist_payment_success': 'பணம் உறுதிப்படுத்தப்பட்டது. நன்றி!',
      'payment_assist_payment_failure': 'பணம் ரத்து செய்யப்பட்டது.',
      
      // Additional prompts as needed
      'item_added_no_customizations': '{itemName} எந்த தனிப்பயனும் இல்லாமல் உங்கள் ஆர்டருக்கு சேர்க்கப்பட்டது.',
      'item_added_with_customizations': '{itemName} {customizations} உடன் உங்கள் ஆர்டருக்கு சேர்க்கப்பட்டது.',
      'item_removed': '{itemName} உங்கள் ஆர்டரிலிருந்து நீக்கப்பட்டது.',
      'payment_assist_reset': 'Pilihan pembayaran telah direset. Mari kita cuba lagi.',

      // SpeechToText Prompts
      'navigating_to_speech_to_text': 'மொழி உதவி பக்கத்திற்கு வழிசெலுத்துகிறது.',
      'speech_not_available': 'மொழி அடையாளம் காண்பது கிடைக்கவில்லை.',
      'speech_error': 'மொழி அடையாளம் காண்பதில் பிழை ஏற்பட்டது.',
      'speech_started': 'கேட்க தொடங்கியது.',
      'speech_stopped': 'கேட்க நிறுத்தப்பட்டது.',
      'no_texts_recognized': 'உரை எதுவும் அடையாளம் காணப்படவில்லை.',
      'confirm_text_success': 'உரை உறுதிப்படுத்தப்பட்டது.',
      'add_phrases_success': 'சொற்றொடர் வெற்றிகரமாக சேர்க்கப்பட்டது.',
      'remove_phrases': 'சொற்றொடர் வெற்றிகரமாக அகற்றப்பட்டது.',
    },
  };
}
