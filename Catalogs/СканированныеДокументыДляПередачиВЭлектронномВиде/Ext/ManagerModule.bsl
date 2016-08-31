﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	// инициализируем контекст ЭДО - модуль обработки
	ТекстСообщения = "";
	КонтекстЭДО = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО(ТекстСообщения);
	Если КонтекстЭДО = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	КонтекстЭДО.ОбработкаПолученияФормы("Справочник", "СканированныеДокументыДляПередачиВЭлектронномВиде", ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка);
	

КонецПроцедуры

Функция ЗагрузитьИзВнешнегоИсточникаПоСтруктуреРезультатаВыбора(СтруктураРезультата) Экспорт
	
	МассивСсылокДобавленныхФайлов = Новый Массив;
	
	ПолноеИмяФайлаОбмена		= СтруктураРезультата.ПолноеИмяФайлаОбмена;
	
	ОрганизацияЗагрузки			= СтруктураРезультата.ОрганизацияСсылка;
	
	ТЗЗагруженныеДокументы 	= ПолучитьИзВременногоХранилища(СтруктураРезультата.АдресТЗЗагруженныеДокументы);
	ТЗУчастникиДокументов 	= ПолучитьИзВременногоХранилища(СтруктураРезультата.АдресТЗУчастникиДокументов);
	ТЗФайлыДокументов 		= ПолучитьИзВременногоХранилища(СтруктураРезультата.АдресТЗФайлыДокументов);
	ТЗРеквизитыУчастников	= ПолучитьИзВременногоХранилища(СтруктураРезультата.АдресТЗРеквизитыУчастников);
	
	СканДокументы = Справочники.СканированныеДокументыДляПередачиВЭлектронномВиде;
	
	КонтекстЭДОСервер = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	
	КаталогОбмена = КонтекстЭДОСервер.СоздатьВременныйКаталогСервер();
	
	// Извлекаем все файлы из ZIP файла обмена
	
	Попытка
		
		ФайлОбмена = Новый Файл(ПолноеИмяФайлаОбмена);
		
		ЧтениеЗИП = Новый ЧтениеZipФайла(ПолноеИмяФайлаОбмена);	
		ЧтениеЗИП.ИзвлечьВсе(КаталогОбмена);
		
	Исключение
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не удалось извлечь файлы из файла обмена'"));
		
		Возврат Неопределено;
	КонецПопытки;
	
	
	// Открываем транзакцию
	НачатьТранзакцию();
	
	Для каждого СтрокаТЗЗагруженныеДокументы Из ТЗЗагруженныеДокументы Цикл
		
		НовыйЭлемент = СканДокументы.СоздатьЭлемент();
		НовыйЭлемент.Организация = ОрганизацияЗагрузки;
		НовыйЭлемент.ВидДокумента = СтрокаТЗЗагруженныеДокументы.ВидДокумента;
		НовыйЭлемент.ДатаДокумента = СтрокаТЗЗагруженныеДокументы.Дата;
		НовыйЭлемент.НомерДокумента = СтрокаТЗЗагруженныеДокументы.Номер;
		НовыйЭлемент.СуммаВсего = СтрокаТЗЗагруженныеДокументы.СуммаВсего;
		НовыйЭлемент.СуммаНалога = СтрокаТЗЗагруженныеДокументы.СуммаНалога;
		НовыйЭлемент.НомерОснования = СтрокаТЗЗагруженныеДокументы.НомерОснования;
		НовыйЭлемент.ДатаОснования = СтрокаТЗЗагруженныеДокументы.ДатаОснования;
		НовыйЭлемент.ПредметДокумента = СтрокаТЗЗагруженныеДокументы.Предмет;
		НовыйЭлемент.НачалоПериода = СтрокаТЗЗагруженныеДокументы.НачалоПериода;
		НовыйЭлемент.КонецПериода = СтрокаТЗЗагруженныеДокументы.КонецПериода;
		
		//Заполним ТЧ РеквизитыУчастников
		ПараметрыОтбораТЗУчастников = Новый Структура;
		ПараметрыОтбораТЗУчастников.Вставить("ИдентификаторДокумента", СтрокаТЗЗагруженныеДокументы.ИдентификаторДокумента);
		
		МассивУчастниковДокумента = ТЗУчастникиДокументов.НайтиСтроки(ПараметрыОтбораТЗУчастников); //массив строк ТЗ УчастникиДокументов
		Для каждого Участник Из МассивУчастниковДокумента Цикл
			НоваяСтрокаУчастник = НовыйЭлемент.РеквизитыУчастников.Добавить();	
			НоваяСтрокаУчастник.Роль = Участник.Роль;
			
			//для остальных реквизитов найдем нужную строку в ТЗРеквизитыУчастников
			СтрокаРеквизитов = ТЗРеквизитыУчастников.Найти(Участник.ИдентификаторУчастника, "ИдентификаторУчастника");
			Если СтрокаРеквизитов = Неопределено Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не удалось определить реквизиты одного из участников документа'") + ":
				|" + СтрокаТЗЗагруженныеДокументы.ПредставлениеДокумента);
				
				ОтменитьТранзакцию();
				Возврат Неопределено;
			КонецЕсли;
			
			НоваяСтрокаУчастник.ЯвляетсяЮрЛицом = СтрокаРеквизитов.ЯвляетсяЮрЛицом;
			
			Если СтрокаРеквизитов.ЯвляетсяЮрЛицом Тогда
				НоваяСтрокаУчастник.ЮрЛицоНаименование = СтрокаРеквизитов.НаименованиеОрганизации;
				НоваяСтрокаУчастник.ЮрЛицоИНН = СтрокаРеквизитов.ИНН;
				НоваяСтрокаУчастник.ЮрЛицоКПП = СтрокаРеквизитов.КПП;
				
			Иначе
				
				НоваяСтрокаУчастник.ФизЛицоИНН 		= СтрокаРеквизитов.ИНН;
				НоваяСтрокаУчастник.ФизЛицоФамилия 	= СтрокаРеквизитов.ФамилияИП;
				НоваяСтрокаУчастник.ФизЛицоИмя 		= СтрокаРеквизитов.ИмяИП;
				НоваяСтрокаУчастник.ФизЛицоОтчество = СтрокаРеквизитов.ОтчествоИП;
				
			КонецЕсли;
			
		КонецЦикла;
		
		Попытка
			НовыйЭлемент.Записать();
		Исключение
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не удалось записать элемент справочника'") + ":
			|" + ОписаниеОшибки());
			
			ОтменитьТранзакцию();
			Возврат Неопределено;
		КонецПопытки;
		
		ОбъектСсылка = НовыйЭлемент.Ссылка;
		
		МассивСсылокДобавленныхФайлов.Добавить(ОбъектСсылка);
		
		//Загрузим файлы документа
		ПараметрыОтбораТЗФайлыДокументов = Новый Структура;
		ПараметрыОтбораТЗФайлыДокументов.Вставить("ИдентификаторДокумента", СтрокаТЗЗагруженныеДокументы.ИдентификаторДокумента);
		
		МассивФайловДокумента = ТЗФайлыДокументов.НайтиСтроки(ПараметрыОтбораТЗФайлыДокументов); //массив строк ТЗФайлыДокументов
		
		// Присоединяем файлы методами БСП		
		Для каждого СтрокаТЗФайлыДокументов Из МассивФайловДокумента Цикл
			
			ИмяЗагружаемогоФайла = СтрокаТЗФайлыДокументов.ИмяНаДиске;
			
			ПолноеИмяЗагружаемогоФайла = КаталогОбмена + ИмяЗагружаемогоФайла;
			ЗагружаемыйФайл = Новый Файл(ПолноеИмяЗагружаемогоФайла);
			
			Если НЕ ЗагружаемыйФайл.Существует() Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'В пакете обмена не обнаружен файл'") + "
				|" + ИмяЗагружаемогоФайла);
				
				ОтменитьТранзакцию();
				Возврат Неопределено;
			КонецЕсли;
			
			//добавим файл
			АдресВременногоХранилищаФайла = ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(ПолноеИмяЗагружаемогоФайла));
			
			ДополнительныеПараметры = Новый Структура();
			ДополнительныеПараметры.Вставить("ВладелецФайлов", 		ОбъектСсылка);
			ДополнительныеПараметры.Вставить("ИмяБезРасширения", 	СтрокаТЗФайлыДокументов.Имя);
			ДополнительныеПараметры.Вставить("Автор", 				Неопределено);
			ДополнительныеПараметры.Вставить("РасширениеБезТочки", 	Неопределено);
			ДополнительныеПараметры.Вставить("ВремяИзмененияУниверсальное", Неопределено);
			
			ПрисоединенныйФайлСсылка = ПрисоединенныеФайлы.ДобавитьПрисоединенныйФайл(
				ДополнительныеПараметры,
				АдресВременногоХранилищаФайла);
				
			Если СтрокаТЗФайлыДокументов.НомерСтраницы <> 0 Тогда
				ПрисоединенныйФайлОбъект = ПрисоединенныйФайлСсылка.ПолучитьОбъект();
				ПрисоединенныйФайлОбъект.НомерСтраницы = СтрокаТЗФайлыДокументов.НомерСтраницы;
				ПрисоединенныйФайлОбъект.Записать();
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
	// Завершаем транзакцию
	ЗафиксироватьТранзакцию();
	
	//Удаляем файлы временного каталога
	Попытка
		
		УдалитьФайлы(КаталогОбмена);
		УдалитьФайлы(ПолноеИмяФайлаОбмена);
		
	Исключение
	КонецПопытки;
	
	Возврат МассивСсылокДобавленныхФайлов;

КонецФункции

// Обработчик обновления БРО 1.1.6
// ЗаполнитьКонтрагента 	- Заполняет реквизит Контрагент ТЧ РеквизитыУчастников  на основании ИНН
// ЗаполнитьРолиУчастников 	- Заполняет реквизит Роль 		ТЧ РеквизитыУчастников  на основании устаревшего реквизита УдалитьРольУчастника
// ЗаполнитьНаправление 	- Заполняет реквизит Направление
//
Процедура ЗаполнитьНовыеРеквизиты() Экспорт
	
	ЗаполнитьКонтрагента();
	ЗаполнитьРолиУчастников();
	ЗаполнитьНаправление();
	
КонецПроцедуры

Функция ПолучитьКонтрагентаПоИНН(ИНН)
	
	МассивКонтрагентов = Новый Массив;
	
	Если ЭлектронныйДокументооборотСКонтролирующимиОрганами.РеквизитыСправочникаКонтрагентовДоступны() Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Контрагенты.Ссылка
		|ИЗ
		|	Справочник.Контрагенты КАК Контрагенты
		|ГДЕ
		|	Контрагенты.ИНН = &ОтборИНН";
		
		Запрос.УстановитьПараметр("ОтборИНН", ИНН);
		
		Результат = Запрос.Выполнить();
		Выборка = Результат.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			МассивКонтрагентов.Добавить(Выборка.Ссылка);
		КонецЦикла;
		
	Иначе
		
		ЭлектронныйДокументооборотСКонтролирующимиОрганамиПереопределяемый.ПолучитьМассивКонтрагентовПоИНН(ИНН, МассивКонтрагентов);
		
	КонецЕсли;
	
	Если МассивКонтрагентов.Количество() = 0 Тогда
		
		Возврат Неопределено;
		
	Иначе
		
		Возврат МассивКонтрагентов[0];
		
	КонецЕсли;
	
КонецФункции

// Обработчик обновления БРО 1.1.6
// Заполняет реквизит Контрагент ТЧ РеквизитыУчастников  на основании ИНН
//
Процедура ЗаполнитьКонтрагента() 
	
	Если НЕ ЭлектронныйДокументооборотСКонтролирующимиОрганами.РеквизитыСправочникаКонтрагентовДоступны() Тогда
		Возврат;			
	КонецЕсли;	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	СканированныеДокументыДляПередачиВЭлектронномВидеРеквизитыУчастников.Ссылка КАК Ссылка,
		|	СканированныеДокументыДляПередачиВЭлектронномВидеРеквизитыУчастников.НомерСтроки,
		|	СканированныеДокументыДляПередачиВЭлектронномВидеРеквизитыУчастников.ЯвляетсяЮрЛицом,
		|	СканированныеДокументыДляПередачиВЭлектронномВидеРеквизитыУчастников.ЮрЛицоИНН,
		|	СканированныеДокументыДляПередачиВЭлектронномВидеРеквизитыУчастников.ФизЛицоИНН
		|ИЗ
		|	Справочник.СканированныеДокументыДляПередачиВЭлектронномВиде.РеквизитыУчастников КАК СканированныеДокументыДляПередачиВЭлектронномВидеРеквизитыУчастников
		|ГДЕ
		|	СканированныеДокументыДляПередачиВЭлектронномВидеРеквизитыУчастников.Контрагент = ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)
		|ИТОГИ ПО
		|	Ссылка";

	РезультатЗапроса = Запрос.Выполнить();

	ВыборкаДокумент = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);

	Пока ВыборкаДокумент.Следующий() Цикл
		ВыборкаУчастник = ВыборкаДокумент.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);

		НачатьТранзакцию();
		
		Попытка
			
			СканДокументОбъект = ВыборкаДокумент.Ссылка.ПолучитьОбъект();
			ТребуетсяЗапись = Ложь;
			Пока ВыборкаУчастник.Следующий() Цикл
				
				УчастникЯвляетсяЮрЛицом = ВыборкаУчастник.ЯвляетсяЮрЛицом;
				
				Если ВыборкаУчастник.ЯвляетсяЮрЛицом Тогда
					ИНН = ВыборкаУчастник.ЮрЛицоИНН; 
				Иначе
					ИНН = ВыборкаУчастник.ФизЛицоИНН; 
				КонецЕсли;
				
				Если ЗначениеЗаполнено(ИНН) Тогда
					
					Контрагент = ПолучитьКонтрагентаПоИНН(ИНН);
					Если ЗначениеЗаполнено(Контрагент) Тогда
						
						ТребуетсяЗапись = Истина;
						
						СтрокаУчастника = СканДокументОбъект.РеквизитыУчастников[ВыборкаУчастник.НомерСтроки - 1];
						СтрокаУчастника.Контрагент = Контрагент;
						
					КонецЕсли;	
					
				КонецЕсли;
				
			КонецЦикла;
			
			Если ТребуетсяЗапись Тогда
				
				ОбновлениеИнформационнойБазы.ЗаписатьДанные(СканДокументОбъект);	
			
			КонецЕсли;
			
		Исключение
			
			ОтменитьТранзакцию();
			// Пишем в журнал
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			ЗаписьЖурналаРегистрации(
				НСтр("ru = 'Электронный документооборот с контролирующими органами. Сканированные документы для передачи в электронном виде'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), 
				УровеньЖурналаРегистрации.Предупреждение, , , ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
			Продолжить;	
		КонецПопытки;
		
		ЗафиксироватьТранзакцию();
		
	КонецЦикла;

КонецПроцедуры
	 
// Обработчик обновления БРО 1.1.6
// Заполняет реквизит Роль ТЧ РеквизитыУчастников  на основании устаревшего реквизита УдалитьРольУчастника
//
Процедура ЗаполнитьРолиУчастников() 
	
	СоответствиеРолей = ПолучитьСоответствиеРолейУчастников();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	СканированныеДокументыДляПередачиВЭлектронномВидеРеквизитыУчастников.Ссылка КАК Ссылка,
		|	СканированныеДокументыДляПередачиВЭлектронномВидеРеквизитыУчастников.УдалитьРольУчастника,
		|	СканированныеДокументыДляПередачиВЭлектронномВидеРеквизитыУчастников.НомерСтроки
		|ИЗ
		|	Справочник.СканированныеДокументыДляПередачиВЭлектронномВиде.РеквизитыУчастников КАК СканированныеДокументыДляПередачиВЭлектронномВидеРеквизитыУчастников
		|ГДЕ
		|	СканированныеДокументыДляПередачиВЭлектронномВидеРеквизитыУчастников.Роль = ЗНАЧЕНИЕ(Перечисление.РолиУчастниковСделкиДокументаПоТребованиюФНС.ПустаяСсылка)
		|	И СканированныеДокументыДляПередачиВЭлектронномВидеРеквизитыУчастников.УдалитьРольУчастника <> """"
		|ИТОГИ ПО
		|	Ссылка";

	РезультатЗапроса = Запрос.Выполнить();

	ВыборкаДокумент = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);

	Пока ВыборкаДокумент.Следующий() Цикл
		ВыборкаУчастник = ВыборкаДокумент.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);

		НачатьТранзакцию();
		
		Попытка
			
			СканДокументОбъект = ВыборкаДокумент.Ссылка.ПолучитьОбъект();
			
			Пока ВыборкаУчастник.Следующий() Цикл
				
				ПеречислениеРоль = СоответствиеРолей[нрег(ВыборкаУчастник.УдалитьРольУчастника)];
				Если ПеречислениеРоль <> Неопределено Тогда
					СтрокаУчастника = СканДокументОбъект.РеквизитыУчастников[ВыборкаУчастник.НомерСтроки - 1];
					СтрокаУчастника.Роль = ПеречислениеРоль;
					СтрокаУчастника.УдалитьРольУчастника = ""; //очищаем старое значение
				КонецЕсли;
				
			КонецЦикла;
			
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(СканДокументОбъект);
			
		Исключение
			
			ОтменитьТранзакцию();
			// Пишем в журнал
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			ЗаписьЖурналаРегистрации(
				НСтр("ru = 'Электронный документооборот с контролирующими органами. Сканированные документы для передачи в электронном виде'"), 
				УровеньЖурналаРегистрации.Предупреждение, , , ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
			Продолжить;	
		КонецПопытки;
		
		ЗафиксироватьТранзакцию();
		
	КонецЦикла;

КонецПроцедуры

// вспомогательная функция для процедуры ЗаполнитьРолиУчастников
Функция ПолучитьСоответствиеРолейУчастников() 
	
	СоответствиеРолей = Новый Соответствие;
	СоответствиеРолей.Вставить("агент", 						Перечисления.РолиУчастниковСделкиДокументаПоТребованиюФНС.Агент);
	СоответствиеРолей.Вставить("акционер", 						Перечисления.РолиУчастниковСделкиДокументаПоТребованиюФНС.Акционер);
	СоответствиеРолей.Вставить("арендатор", 					Перечисления.РолиУчастниковСделкиДокументаПоТребованиюФНС.Арендатор);
	СоответствиеРолей.Вставить("арендодатель", 					Перечисления.РолиУчастниковСделкиДокументаПоТребованиюФНС.Арендодатель);
	СоответствиеРолей.Вставить("векселедатель", 				Перечисления.РолиУчастниковСделкиДокументаПоТребованиюФНС.Векселедатель);
	СоответствиеРолей.Вставить("векселеполучатель", 			Перечисления.РолиУчастниковСделкиДокументаПоТребованиюФНС.Векселеполучатель);
	СоответствиеРолей.Вставить("генеральный подрядчик", 		Перечисления.РолиУчастниковСделкиДокументаПоТребованиюФНС.ГенеральныйПодрядчик);
	СоответствиеРолей.Вставить("грузоотправитель", 				Перечисления.РолиУчастниковСделкиДокументаПоТребованиюФНС.Грузоотправитель);
	СоответствиеРолей.Вставить("грузополучатель", 				Перечисления.РолиУчастниковСделкиДокументаПоТребованиюФНС.Грузополучатель);
	СоответствиеРолей.Вставить("декларант", 					Перечисления.РолиУчастниковСделкиДокументаПоТребованиюФНС.Декларант);
	СоответствиеРолей.Вставить("займодатель", 					Перечисления.РолиУчастниковСделкиДокументаПоТребованиюФНС.Займодатель);
	СоответствиеРолей.Вставить("займополучатель (заемщик)", 	Перечисления.РолиУчастниковСделкиДокументаПоТребованиюФНС.Займополучатель);
	СоответствиеРолей.Вставить("заказчик", 						Перечисления.РолиУчастниковСделкиДокументаПоТребованиюФНС.Заказчик);
	СоответствиеРолей.Вставить("импортер", 						Перечисления.РолиУчастниковСделкиДокументаПоТребованиюФНС.Импортер);
	СоответствиеРолей.Вставить("инвестор", 						Перечисления.РолиУчастниковСделкиДокументаПоТребованиюФНС.Инвестор);
	СоответствиеРолей.Вставить("исполнитель", 					Перечисления.РолиУчастниковСделкиДокументаПоТребованиюФНС.Исполнитель);
	СоответствиеРолей.Вставить("лицо, составившее документ", 	Перечисления.РолиУчастниковСделкиДокументаПоТребованиюФНС.ЛицоСоставившееДокумент); 
	СоответствиеРолей.Вставить("отправитель", 					Перечисления.РолиУчастниковСделкиДокументаПоТребованиюФНС.Отправитель);
	СоответствиеРолей.Вставить("перевозчик", 					Перечисления.РолиУчастниковСделкиДокументаПоТребованиюФНС.Перевозчик);
	СоответствиеРолей.Вставить("плательщик", 					Перечисления.РолиУчастниковСделкиДокументаПоТребованиюФНС.Плательщик);
	СоответствиеРолей.Вставить("поверенный", 					Перечисления.РолиУчастниковСделкиДокументаПоТребованиюФНС.Поверенный);
	СоответствиеРолей.Вставить("подрядчик", 					Перечисления.РолиУчастниковСделкиДокументаПоТребованиюФНС.Подрядчик);
	СоответствиеРолей.Вставить("покупатель", 					Перечисления.РолиУчастниковСделкиДокументаПоТребованиюФНС.Покупатель);
	СоответствиеРолей.Вставить("получатель", 					Перечисления.РолиУчастниковСделкиДокументаПоТребованиюФНС.Получатель);
	СоответствиеРолей.Вставить("пользователь", 					Перечисления.РолиУчастниковСделкиДокументаПоТребованиюФНС.Пользователь);
	СоответствиеРолей.Вставить("посредник", 					Перечисления.РолиУчастниковСделкиДокументаПоТребованиюФНС.Посредник);
	СоответствиеРолей.Вставить("поставщик", 					Перечисления.РолиУчастниковСделкиДокументаПоТребованиюФНС.Поставщик);
	СоответствиеРолей.Вставить("продавец", 						Перечисления.РолиУчастниковСделкиДокументаПоТребованиюФНС.Продавец);
	СоответствиеРолей.Вставить("работник", 						Перечисления.РолиУчастниковСделкиДокументаПоТребованиюФНС.Работник);
	СоответствиеРолей.Вставить("работодатель", 					Перечисления.РолиУчастниковСделкиДокументаПоТребованиюФНС.Работодатель);
	СоответствиеРолей.Вставить("страхователь", 					Перечисления.РолиУчастниковСделкиДокументаПоТребованиюФНС.Страхователь);
	СоответствиеРолей.Вставить("страховщик", 					Перечисления.РолиУчастниковСделкиДокументаПоТребованиюФНС.Страховщик);
	СоответствиеРолей.Вставить("субподрядчик", 					Перечисления.РолиУчастниковСделкиДокументаПоТребованиюФНС.Субподрядчик);
	СоответствиеРолей.Вставить("участник", 						Перечисления.РолиУчастниковСделкиДокументаПоТребованиюФНС.Участник);
	СоответствиеРолей.Вставить("учредитель", 					Перечисления.РолиУчастниковСделкиДокументаПоТребованиюФНС.Учредитель);
	СоответствиеРолей.Вставить("хранитель", 					Перечисления.РолиУчастниковСделкиДокументаПоТребованиюФНС.Хранитель);
	СоответствиеРолей.Вставить("экспедитор", 					Перечисления.РолиУчастниковСделкиДокументаПоТребованиюФНС.Экспедитор);
	СоответствиеРолей.Вставить("экспортер", 					Перечисления.РолиУчастниковСделкиДокументаПоТребованиюФНС.Экспортер);
	СоответствиеРолей.Вставить("эмитент", 						Перечисления.РолиУчастниковСделкиДокументаПоТребованиюФНС.Эмитент);

	Возврат СоответствиеРолей;

КонецФункции

// Обработчик обновления БРО 1.1.6
// Заполняет реквизит Направление
//
Процедура ЗаполнитьНаправление() 
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СканированныеДокументыДляПередачиВЭлектронномВидеРеквизитыУчастников.Ссылка КАК Ссылка,
		|	СканированныеДокументыДляПередачиВЭлектронномВидеРеквизитыУчастников.Ссылка.Организация КАК Организация,
		|	СканированныеДокументыДляПередачиВЭлектронномВидеРеквизитыУчастников.Ссылка.ВидДокумента КАК ВидДокумента,
		|	СканированныеДокументыДляПередачиВЭлектронномВидеРеквизитыУчастников.Роль,
		|	СканированныеДокументыДляПередачиВЭлектронномВидеРеквизитыУчастников.ЮрЛицоИНН,
		|	СканированныеДокументыДляПередачиВЭлектронномВидеРеквизитыУчастников.ЮрЛицоКПП,
		|	СканированныеДокументыДляПередачиВЭлектронномВидеРеквизитыУчастников.ФизЛицоИНН,
		|	СканированныеДокументыДляПередачиВЭлектронномВидеРеквизитыУчастников.ЯвляетсяЮрЛицом
		|ИЗ
		|	Справочник.СканированныеДокументыДляПередачиВЭлектронномВиде.РеквизитыУчастников КАК СканированныеДокументыДляПередачиВЭлектронномВидеРеквизитыУчастников
		|ГДЕ
		|	СканированныеДокументыДляПередачиВЭлектронномВидеРеквизитыУчастников.Ссылка.Направление = ЗНАЧЕНИЕ(Перечисление.НаправленияДокументаПоТребованиюФНС.ПустаяСсылка)
		|	И СканированныеДокументыДляПередачиВЭлектронномВидеРеквизитыУчастников.Ссылка.ВидДокумента В(&МассивВидовДокументовСНаправлением)
		|ИТОГИ ПО
		|	Организация,
		|	Ссылка";

		
	МассивВидовДокументовСНаправлением = Новый Массив;
	МассивВидовДокументовСНаправлением.Добавить(Перечисления.ВидыПредставляемыхДокументов.АктПриемкиСдачиРабот);
	МассивВидовДокументовСНаправлением.Добавить(Перечисления.ВидыПредставляемыхДокументов.СчетФактура);
	МассивВидовДокументовСНаправлением.Добавить(Перечисления.ВидыПредставляемыхДокументов.КорректировочныйСчетФактура);
	МассивВидовДокументовСНаправлением.Добавить(Перечисления.ВидыПредставляемыхДокументов.ТоварнаяНакладнаяТОРГ12);
	МассивВидовДокументовСНаправлением.Добавить(Перечисления.ВидыПредставляемыхДокументов.ТоварноТранспортнаяНакладная);
	
	Запрос.Параметры.Вставить("МассивВидовДокументовСНаправлением", МассивВидовДокументовСНаправлением);	
	РезультатЗапроса = Запрос.Выполнить();

	ВыборкаОрганизация = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаОрганизация.Следующий() Цикл
		
		//определим реквизиты организации
		Организация = ВыборкаОрганизация.Организация;
		ОргЯвляетсяЮрЛицом = РегламентированнаяОтчетностьВызовСервера.ЭтоЮридическоеЛицо(Организация);
		
		Если ОргЯвляетсяЮрЛицом Тогда
			
			СтрокаСведений = "ИННЮЛ, КППЮЛ";	
			СведенияОбОрганизации = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(Организация, ТекущаяДатаСеанса(), СтрокаСведений);	
			ЮрЛицоИНН = СведенияОбОрганизации.ИННЮЛ; 
			ЮрЛицоКПП = СведенияОбОрганизации.КППЮЛ; 
			
		Иначе
			
			СтрокаСведений = "ИННФЛ";	
			СведенияОбОрганизации = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(Организация, ТекущаяДатаСеанса(), СтрокаСведений);	
			ФизЛицоИНН  = СведенияОбОрганизации.ИННФЛ;
			
		КонецЕсли; 
		
	
		//перебираем документы по определенной организации
		ВыборкаДокумент = ВыборкаОрганизация.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		Пока ВыборкаДокумент.Следующий() Цикл
			
			ВидДокумента = ВыборкаДокумент.ВидДокумента;
			
			ВыборкаУчастник = ВыборкаДокумент.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			
			МассивРолейОрганизации = Новый Массив;
			
			Пока ВыборкаУчастник.Следующий() Цикл
				
				//определяем, является ли участник организацией
				Если 
					((ОргЯвляетсяЮрЛицом И ВыборкаУчастник.ЯвляетсяЮрЛицом) 
					И 
					(ЮрЛицоИНН = ВыборкаУчастник.ЮрЛицоИНН И ЮрЛицоКПП = ВыборкаУчастник.ЮрЛицоКПП))
					ИЛИ
					((НЕ ОргЯвляетсяЮрЛицом И НЕ ВыборкаУчастник.ЯвляетсяЮрЛицом) 
					И 
					(ФизЛицоИНН = ВыборкаУчастник.ФизЛицоИНН))
					Тогда
					Если ЗначениеЗаполнено(ВыборкаУчастник.Роль) Тогда
						МассивРолейОрганизации.Добавить(ВыборкаУчастник.Роль);
					КонецЕсли;
				КонецЕсли;
				
			КонецЦикла;
			
			Направление = ОпределитьНаправлениеПоВидуДокументаИРолям(ВидДокумента, МассивРолейОрганизации);
			
			
			Если Направление <> Неопределено Тогда
				
				НачатьТранзакцию();
				
				Попытка
					
					СканДокументОбъект = ВыборкаДокумент.Ссылка.ПолучитьОбъект();
					
					СканДокументОбъект.Направление = Направление;
					
					ОбновлениеИнформационнойБазы.ЗаписатьДанные(СканДокументОбъект);
					
				Исключение
					
					ОтменитьТранзакцию();
					// Пишем в журнал
					ИнформацияОбОшибке = ИнформацияОбОшибке();
					ЗаписьЖурналаРегистрации(
						НСтр("ru = 'Электронный документооборот с контролирующими органами. Сканированные документы для передачи в электронном виде'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), 
						УровеньЖурналаРегистрации.Предупреждение, , , ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
					Продолжить;
					
				КонецПопытки;
				
				ЗафиксироватьТранзакцию();
				
			КонецЕсли;
			
			
		КонецЦикла;
		
	КонецЦикла;

КонецПроцедуры

// вспомогательная функция для процедуры ЗаполнитьНаправление
Функция ОпределитьНаправлениеПоВидуДокументаИРолям(ВидДокумента, МассивРолейОрганизации) 
	
	Направление = Неопределено; //начальное значение
	
	Если ВидДокумента = Перечисления.ВидыПредставляемыхДокументов.СчетФактура Тогда 
		Для каждого Роль Из МассивРолейОрганизации Цикл
			Если Роль = Перечисления.РолиУчастниковСделкиДокументаПоТребованиюФНС.Грузоотправитель 
			ИЛИ Роль = Перечисления.РолиУчастниковСделкиДокументаПоТребованиюФНС.Продавец Тогда
			
				Направление	= Перечисления.НаправленияДокументаПоТребованиюФНС.Выдан;
				Прервать;
			
			ИначеЕсли Роль = Перечисления.РолиУчастниковСделкиДокументаПоТребованиюФНС.Грузополучатель
			ИЛИ Роль = Перечисления.РолиУчастниковСделкиДокументаПоТребованиюФНС.Покупатель Тогда
			
				Направление	= Перечисления.НаправленияДокументаПоТребованиюФНС.Получен;
				Прервать;
			
			КонецЕсли;
		КонецЦикла;		
		
	ИначеЕсли ВидДокумента = Перечисления.ВидыПредставляемыхДокументов.КорректировочныйСчетФактура Тогда
		Для каждого Роль Из МассивРолейОрганизации Цикл
			Если Роль = Перечисления.РолиУчастниковСделкиДокументаПоТребованиюФНС.Продавец Тогда
			
				Направление	= Перечисления.НаправленияДокументаПоТребованиюФНС.Выдан;
				Прервать;
			
			ИначеЕсли Роль = Перечисления.РолиУчастниковСделкиДокументаПоТребованиюФНС.Покупатель Тогда
			
				Направление	= Перечисления.НаправленияДокументаПоТребованиюФНС.Получен;
				Прервать;
			
			КонецЕсли;
		КонецЦикла;	
		
	ИначеЕсли ВидДокумента = Перечисления.ВидыПредставляемыхДокументов.АктПриемкиСдачиРабот Тогда
		Для каждого Роль Из МассивРолейОрганизации Цикл
			Если Роль = Перечисления.РолиУчастниковСделкиДокументаПоТребованиюФНС.Исполнитель 
			ИЛИ Роль = Перечисления.РолиУчастниковСделкиДокументаПоТребованиюФНС.Подрядчик Тогда
			
				Направление	= Перечисления.НаправленияДокументаПоТребованиюФНС.Выдан;
				Прервать;
			
			ИначеЕсли Роль = Перечисления.РолиУчастниковСделкиДокументаПоТребованиюФНС.Заказчик Тогда
			
				Направление	= Перечисления.НаправленияДокументаПоТребованиюФНС.Получен;
				Прервать;
			
			КонецЕсли;
		КонецЦикла;	
		
	ИначеЕсли ВидДокумента = Перечисления.ВидыПредставляемыхДокументов.ТоварнаяНакладнаяТОРГ12 Тогда
		Для каждого Роль Из МассивРолейОрганизации Цикл
			Если Роль = Перечисления.РолиУчастниковСделкиДокументаПоТребованиюФНС.Грузоотправитель 
			ИЛИ Роль = Перечисления.РолиУчастниковСделкиДокументаПоТребованиюФНС.Поставщик Тогда
			
				Направление	= Перечисления.НаправленияДокументаПоТребованиюФНС.Выдан;
				Прервать;
			
			ИначеЕсли Роль = Перечисления.РолиУчастниковСделкиДокументаПоТребованиюФНС.Грузополучатель 
			ИЛИ Роль = Перечисления.РолиУчастниковСделкиДокументаПоТребованиюФНС.Плательщик Тогда
			
				Направление	= Перечисления.НаправленияДокументаПоТребованиюФНС.Получен;
				Прервать;
			
			КонецЕсли;
		КонецЦикла;	

	ИначеЕсли ВидДокумента = Перечисления.ВидыПредставляемыхДокументов.ТоварноТранспортнаяНакладная Тогда
		Для каждого Роль Из МассивРолейОрганизации Цикл
			Если Роль = Перечисления.РолиУчастниковСделкиДокументаПоТребованиюФНС.Грузоотправитель 
			ИЛИ Роль = Перечисления.РолиУчастниковСделкиДокументаПоТребованиюФНС.Поставщик Тогда
			
				Направление	= Перечисления.НаправленияДокументаПоТребованиюФНС.Выдан;
				Прервать;
			
			ИначеЕсли Роль = Перечисления.РолиУчастниковСделкиДокументаПоТребованиюФНС.Грузополучатель 
			ИЛИ Роль = Перечисления.РолиУчастниковСделкиДокументаПоТребованиюФНС.Плательщик Тогда
			
				Направление	= Перечисления.НаправленияДокументаПоТребованиюФНС.Получен;
				Прервать;
			
			КонецЕсли;
		КонецЦикла;	
		
	КонецЕсли; 
	
	Возврат Направление;
	
КонецФункции

#КонецЕсли