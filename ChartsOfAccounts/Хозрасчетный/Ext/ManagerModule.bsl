﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

// Описывает простой рабочий план счетов
//
Функция ОсновнойСчет(Назначение) Экспорт
	
	Если Назначение = "Затраты" Тогда
		
		Возврат ОбщехозяйственныеРасходы;
		
	ИначеЕсли Назначение = "Запасы" Тогда
		
		Возврат ТоварыНаСкладах;
		
	ИначеЕсли Назначение = "ЗапасыВЦенахПродажи" Тогда
		
		Возврат ТоварыВРозничнойТорговлеВПродажныхЦенахАТТ;
		
	ИначеЕсли Назначение = "ОборудованиеНаСкладе" Тогда
		
		Возврат ПриобретениеОбъектовОсновныхСредств;
		
	ИначеЕсли Назначение = "ТоварыПринятыеНаКомиссию" Тогда
		
		Возврат ТоварыНаСкладе;
		
	ИначеЕсли Назначение = "ТоварыПриобретенныеДляКомитента" Тогда
		
		Возврат ТМЦпринятыеНаОтветственноеХранение;
		
	ИначеЕсли Назначение = "ЗапасыОтгруженные" Тогда
		
		// См. также СчетОтгруженныхЗапасов()
		Возврат ПокупныеТоварыОтгруженные;
		
	ИначеЕсли Назначение = "МатериалыПринятыеВПереработку" Тогда
		
		Возврат МатериалыПринятыеВПереработку;
		
	ИначеЕсли Назначение = "МатериалыПринятыеВПереработкуВПроизводстве" Тогда
		
		Возврат МатериалыПринятыеВПереработкуВПроизводстве;
		
	ИначеЕсли Назначение = "ПредъявленныйНДС_Запасы" Тогда
		
		Возврат НДСпоПриобретеннымМПЗ;
		
	ИначеЕсли Назначение = "ПредъявленныйНДС_Расходы" Тогда
		
		Возврат НДСпоПриобретеннымУслугам;
		
	ИначеЕсли Назначение = "ПредъявленныйНДС_ОсновныеСредства" Тогда
		
		Возврат НДСприПриобретенииОсновныхСредств;
		
	ИначеЕсли Назначение = "ПредъявленныйНДС_ОбъектыСтроительства" Тогда
		
		Возврат НДСприСтроительствеОсновныхСредств;
		
	ИначеЕсли Назначение = "ПредъявленныйНДС_НематериальныеАктивы" Тогда
		
		Возврат НДСпоПриобретеннымНематериальнымАктивам;
		
	ИначеЕсли Назначение = "НаличныеДеньги" Тогда
		
		Возврат КассаОрганизации;
		
	ИначеЕсли Назначение = "БезналичныеДеньги" Тогда
		
		Возврат РасчетныеСчета;
		
	ИначеЕсли Назначение = "Инкассация" Тогда
		
		Возврат ПереводыВПути;
		
	ИначеЕсли Назначение = "ПереводыВПути" Тогда
		
		Возврат ПереводыВПути;
		
	ИначеЕсли Назначение = "НаличныеДеньгиВВалюте" Тогда
		
		Возврат КассаОрганизацииВал;
		
	ИначеЕсли Назначение = "БезналичныеДеньгиВВалюте" Тогда
		
		Возврат ВалютныеСчета;
		
	ИначеЕсли Назначение = "ИнкассацияВВалюте" Тогда
		
		Возврат ПереводыВПутиВал;
		
	ИначеЕсли Назначение = "ПереводыВПутиВВалюте" Тогда
		
		Возврат ПереводыВПутиВал;
		
	ИначеЕсли Назначение = "РасходыНаПродажу" Тогда
		
		Возврат ИздержкиОбращения;
		
	ИначеЕсли Назначение = "ОбъектыСтроительства" Тогда
		
		Возврат СтроительствоОбъектовОсновныхСредств;
		
	ИначеЕсли Назначение = "ПрочиеДоходы" Тогда
		
		Возврат ПрочиеДоходы;
		
	ИначеЕсли Назначение = "ПрочиеРасходы" Тогда
		
		Возврат ПрочиеРасходы;
		
	ИначеЕсли Назначение = "ОсновныеСредства" Тогда
		
		Возврат ОСвОрганизации;
		
	ИначеЕсли Назначение = "ОсновныеСредстваАмортизация" Тогда
		
		Возврат АмортизацияОС_01;
		
	ИначеЕсли Назначение = "НематериальныеАктивы" Тогда
		
		Возврат НематериальныеАктивыОрганизации;
		
	ИначеЕсли Назначение = "НематериальныеАктивыАмортизация" Тогда
		
		Возврат АмортизацияНематериальныхАктивов;
		
	ИначеЕсли Назначение = "Налоги" Тогда
		
		Возврат ПрочиеНалогиИСборы;
		
	ИначеЕсли Назначение = "Зарплата" Тогда
		
		Возврат РасчетыСПерсоналомПоОплатеТруда;
		
	ИначеЕсли Назначение = "Подотчет" Тогда
		
		Возврат РасчетыСПодотчетнымиЛицами;
		
	ИначеЕсли Назначение = "ПодотчетВВалюте" Тогда
		
		Возврат РасчетыСПодотчетнымиЛицамиВал;
		
	ИначеЕсли Назначение = "УставныйКапитал" Тогда
		
		Возврат УставныйКапитал_ПрочийКапитал;
		
	ИначеЕсли Назначение = "Учредители" Тогда
		
		Возврат РасчетыПоВкладамВУставныйКапитал;
		
	Иначе
		
		Возврат ПустаяСсылка();
		
	КонецЕсли;
	
КонецФункции

Функция СчетОтгруженныхЗапасов(СчетЗапасов) Экспорт
	
	Если Не ЗначениеЗаполнено(СчетЗапасов) Тогда
		Возврат ОсновнойСчет("ЗапасыОтгруженные");
	КонецЕсли;
	
	// Правила определения счета отгруженных запасов по основному счету запасов
	СоответствиеСчетов = Новый Соответствие;
	СоответствиеСчетов.Вставить(
		ГотоваяПродукция,             // 43
		ГотоваяПродукцияОтгруженная); // 45.02
	СоответствиеСчетов.Вставить(
		Товары,                       // 41
		ПокупныеТоварыОтгруженные);   // 45.01
	СоответствиеСчетов.Вставить(
		ТоварыНаСкладе,               // 004.01
		ТоварыПереданныеНаКомиссию);  // 004.02
		
	// ... для счетов, не перечисленных выше
	Если СчетЗапасов.Забалансовый Тогда
		СчетОтгруженныхЗапасов = СчетЗапасов;
	Иначе
		СчетОтгруженныхЗапасов = ПрочиеТоварыОтгруженные; // 45.03
	КонецЕсли;
	
	// Применение правил
	Для Каждого ЭлементСоответствияСчетов Из СоответствиеСчетов Цикл
		Если БухгалтерскийУчетВызовСервераПовтИсп.СчетВИерархии(СчетЗапасов, ЭлементСоответствияСчетов.Ключ) Тогда
			СчетОтгруженныхЗапасов = ЭлементСоответствияСчетов.Значение;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Возврат СчетОтгруженныхЗапасов;
		
КонецФункции

Функция ПолучитьСчетаИсключения() Экспорт
	
	МассивСчетовИсключений = Новый Массив;
	
	МассивСчетовИсключений.Добавить(ПланыСчетов.Хозрасчетный.ВекселяВыданные); 											// 60.03
	МассивСчетовИсключений.Добавить(ПланыСчетов.Хозрасчетный.ВекселяПолученные); 										// 62.03
	МассивСчетовИсключений.Добавить(ПланыСчетов.Хозрасчетный.РасчетыПоИмущественномуЛичномуИДобровольномуСтрахованию);	// 76.01
	МассивСчетовИсключений.Добавить(ПланыСчетов.Хозрасчетный.РасчетыПоПричитающимсяДивидендам); 						// 76.03
	МассивСчетовИсключений.Добавить(ПланыСчетов.Хозрасчетный.РасчетыПоИмущественномуИЛичномуСтрахованиюВал);      		// 76.21
	МассивСчетовИсключений.Добавить(ПланыСчетов.Хозрасчетный.СпецоснасткаИСпецодеждаВЭксплуатации);                     // 10.11
	МассивСчетовИсключений.Добавить(ПланыСчетов.Хозрасчетный.РасчетыПоАренде);											// 76.07
	МассивСчетовИсключений.Добавить(ПланыСчетов.Хозрасчетный.АрендныеОбязательства);									// 76.07.1
	МассивСчетовИсключений.Добавить(ПланыСчетов.Хозрасчетный.РасчетыПоАрендеВал);										// 76.27
	МассивСчетовИсключений.Добавить(ПланыСчетов.Хозрасчетный.АрендныеОбязательстваВал);									// 76.27.1
	МассивСчетовИсключений.Добавить(ПланыСчетов.Хозрасчетный.РасчетыПоАрендеУЕ);										// 76.37
	МассивСчетовИсключений.Добавить(ПланыСчетов.Хозрасчетный.АрендныеОбязательстваУЕ);									// 76.37.1
	МассивСчетовИсключений.Добавить(ПланыСчетов.Хозрасчетный.РасчетыПоАвансамПолученнымУЕВСчетОтгрузки);				// 62.ОТ
	МассивСчетовИсключений.Добавить(ПланыСчетов.Хозрасчетный.НДСРасчетыПоОтгрузкеУЕ);									// ОТ

	Возврат Новый ФиксированныйМассив(МассивСчетовИсключений);
	
КонецФункции

Функция СчетаУчетаВзносовФОТ() Экспорт

	СчетаУчета = Новый Массив;
	СчетаУчета.Добавить(ПланыСчетов.Хозрасчетный.ФСС);       // 69.01
	СчетаУчета.Добавить(ПланыСчетов.Хозрасчетный.ФСС_НСиПЗ); // 69.11
	СчетаУчета.Добавить(ПланыСчетов.Хозрасчетный.ПФР_страх); // 69.02.1 (до 2014 года)
	СчетаУчета.Добавить(ПланыСчетов.Хозрасчетный.ПФР_нак);   // 69.02.2 (до 2014 года)
	СчетаУчета.Добавить(ПланыСчетов.Хозрасчетный.ПФР_ОПС);   // 69.02.7 (с 2014 года)
	СчетаУчета.Добавить(ПланыСчетов.Хозрасчетный.ФФОМС);     // 69.03.1
	СчетаУчета.Добавить(ПланыСчетов.Хозрасчетный.ТФОМС);     // 69.03.2
	
	Возврат Новый ФиксированныйМассив(СчетаУчета);
	
КонецФункции

Функция СчетаУчетаФиксированныхВзносов() Экспорт
	
	СчетаВзносов = Новый Массив;
	
	СчетаВзносов.Добавить(ПланыСчетов.Хозрасчетный.ПФР_Страх_СтраховойГод); // 69.06.1
	СчетаВзносов.Добавить(ПланыСчетов.Хозрасчетный.ПФР_Нак_СтраховойГод);   // 69.06.2
	СчетаВзносов.Добавить(ПланыСчетов.Хозрасчетный.ФОМС_СтраховойГод);      // 69.06.3
	СчетаВзносов.Добавить(ПланыСчетов.Хозрасчетный.ФСС_СтраховойГод);       // 69.06.4
	СчетаВзносов.Добавить(ПланыСчетов.Хозрасчетный.ПФР_ОПС_ИП);             // 69.06.5
	
	Возврат БухгалтерскийУчет.ПолучитьМассивСчетовССубсчетами(СчетаВзносов, Ложь,, Ложь);
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ПЕЧАТИ

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт

	// Накладная на оприходование товаров
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ПростойСписок";
	КомандаПечати.Представление = НСтр("ru = 'Простой список'");
	КомандаПечати.ЗаголовокФормы= НСтр("ru = 'План счетов'");
	КомандаПечати.СписокФорм    = "ФормаСписка, ФормаВыбора";
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	
	// Накладная на оприходование товаров
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "СПодробнымиОписаниями";
	КомандаПечати.Представление = НСтр("ru = 'С подробными описаниями'");
	КомандаПечати.ЗаголовокФормы= НСтр("ru = 'План счетов (с подробными описаниями)'");
	КомандаПечати.СписокФорм    = "ФормаСписка, ФормаВыбора";
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	
КонецПроцедуры

Функция ПечатьПланаСчетов(ВыводитьОписания = Ложь, ПараметрыПриказа = Неопределено) Экспорт
	
	Макет = ПланыСчетов.Хозрасчетный.ПолучитьМакет("Описание");
	
	ТабДокумент = Новый ТабличныйДокумент;
	
	Если ПараметрыПриказа <> Неопределено Тогда
		Приказ = Макет.ПолучитьОбласть("Приказ");
		Приказ.Параметры.Заполнить(ПараметрыПриказа);
		ТабДокумент.Вывести(Приказ);
	КонецЕсли;
	
	Шапка = Макет.ПолучитьОбласть("Шапка");
	Если ПараметрыПриказа <> Неопределено Тогда
		Шапка.Параметры.Заполнить(ПараметрыПриказа);
	Иначе
		Шапка.Параметры.ЗаголовокШапки = НСтр("ru='План счетов бухгалтерского учета'");
	КонецЕсли;
	ТабДокумент.Вывести(Шапка);
	
	ТабДокумент.ФиксацияСверху = ТабДокумент.ВысотаТаблицы;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ИспользоватьВалютныйУчет", БухгалтерскийУчетПереопределяемый.ИспользоватьВалютныйУчет());
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаПланаСчетов.Ссылка КАК Ссылка,
	|	ТаблицаПланаСчетов.ЭтоГруппа КАК ЭтоГруппа,
	|	ТаблицаПланаСчетов.Ссылка.Код КАК Код,
	|	ТаблицаПланаСчетов.Ссылка.Наименование КАК Наименование,
	|	ТаблицаПланаСчетов.Ссылка.Валютный КАК Валютный,
	|	ТаблицаПланаСчетов.Ссылка.Количественный КАК Количественный,
	|	ТаблицаПланаСчетов.Ссылка.Забалансовый КАК Забалансовый,
	|	ТаблицаПланаСчетов.Ссылка.Вид КАК Вид,
	|	ТаблицаПланаСчетов.Ссылка.ВидыСубконто.(
	|		НомерСтроки КАК НомерСтроки,
	|		ВидСубконто.Наименование КАК Наименование,
	|		ТолькоОбороты КАК ТолькоОбороты
	|	) КАК ВидыСубконто
	|ИЗ
	|	(ВЫБРАТЬ
	|		ПланСчетов1.Ссылка КАК Ссылка,
	|		ВЫБОР
	|			КОГДА КОЛИЧЕСТВО(ПланСчетов2.Ссылка) > 0
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ ЛОЖЬ
	|		КОНЕЦ КАК ЭтоГруппа
	|	ИЗ
	|		ПланСчетов.Хозрасчетный КАК ПланСчетов1
	|			ЛЕВОЕ СОЕДИНЕНИЕ ПланСчетов.Хозрасчетный КАК ПланСчетов2
	|			ПО ПланСчетов1.Ссылка = ПланСчетов2.Родитель
	|	ГДЕ
	|		ПланСчетов1.ПометкаУдаления = ЛОЖЬ
	|	
	|	СГРУППИРОВАТЬ ПО
	|		ПланСчетов1.Ссылка) КАК ТаблицаПланаСчетов
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Константы КАК Константы
	|		ПО (&ИспользоватьВалютныйУчет
	|				ИЛИ НЕ &ИспользоватьВалютныйУчет
	|					И НЕ ТаблицаПланаСчетов.Ссылка.Валютный)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ТаблицаПланаСчетов.Ссылка.Порядок";
	
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.ЭтоГруппа Тогда
			Строка = Макет.ПолучитьОбласть("Группа");
		Иначе
			Строка = Макет.ПолучитьОбласть("Строка");
		КонецЕсли;
			
		Строка.Параметры.Заполнить(Выборка);
			
		Если Выборка.Вид = ВидСчета.Активный Тогда
			Строка.Параметры.Активность = "А";
		ИначеЕсли Выборка.Вид = ВидСчета.Пассивный Тогда
			Строка.Параметры.Активность = "П";
		Иначе
			Строка.Параметры.Активность = "АП";
		КонецЕсли;
		
		ВидыСубконто = Выборка.ВидыСубконто.Выбрать();
		Пока ВидыСубконто.Следующий() Цикл
			Строка.Параметры["Субконто" + ВидыСубконто.НомерСтроки] = ?(ВидыСубконто.ТолькоОбороты, "(об) ", "") + ВидыСубконто.Наименование;
		КонецЦикла;
			
		ТабДокумент.Вывести(Строка);
		
		Если ВыводитьОписания Тогда
		
			Попытка
				Описание = Макет.ПолучитьОбласть(ПланыСчетов[Выборка.Ссылка.Метаданные().Имя].ПолучитьИмяПредопределенного(Выборка.Ссылка));
				ТабДокумент.Вывести(Описание);
			Исключение
				// Запись в журнал регистрации не требуется
			КонецПопытки;
		
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ТабДокумент;
	
КонецФункции

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПростойСписок") Тогда
		// Формируем табличный документ и добавляем его в коллекцию печатных форм.
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "ПростойСписок", "План счетов бухгалтерского учета", ПечатьПланаСчетов());                                            
	КонецЕсли;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "СПодробнымиОписаниями") Тогда
		// Формируем табличный документ и добавляем его в коллекцию печатных форм.
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "СПодробнымиОписаниями", "План счетов бухгалтерского учета", ПечатьПланаСчетов(Истина));                                            
	КонецЕсли;
		
КонецПроцедуры

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Если Не БухгалтерскийУчетПереопределяемый.ИспользоватьВалютныйУчет() Тогда
		Параметры.Отбор.Вставить("Валютный", Ложь);
	КонецЕсли;
	
	// При вводе кода счета с цифровой клавиатуры заменяем запятую на точку
	Если ТипЗнч(Параметры.СтрокаПоиска) = Тип("Строка") Тогда
		Параметры.СтрокаПоиска = СтрЗаменить(Параметры.СтрокаПоиска, ",", ".");
	КонецЕсли;
	
КонецПроцедуры

// Обработка добавления счетов 19.10 и 68.42
//
Процедура ОбработатьДобавлениеСчетовУчетаНДСВТаможенномСоюзе() Экспорт
	
	Если ПланыОбмена.ГлавныйУзел() <> Неопределено Тогда // В подчиненных узлах РИБ не выполняется
		Возврат;
	КонецЕсли;
	
	СчетОбъект = ПланыСчетов.Хозрасчетный.НДСУплачиваемыйПриИмпортеИзТаможенногоСоюза.ПолучитьОбъект();
	СчетОбъект.КодБыстрогоВыбора = "1910";
	
	ПараметрыУчета = ОбщегоНазначенияБПВызовСервера.ОпределитьПараметрыУчета();

	Если ПараметрыУчета.ВестиУчетНДСПоСпособам Тогда
		
		СтрокаСубконто = СчетОбъект.ВидыСубконто.Добавить();
		
		ИзмененыПараметрыСубконто = Ложь;
		ПараметрыУчета.ВестиУчетНДСПоСпособам = Истина;
		Отказ = Ложь;
		
		ОбщегоНазначенияБПВызовСервера.ПрименитьПараметрыУчета(ПараметрыУчета, ИзмененыПараметрыСубконто, Отказ);
		
	КонецЕсли;
		
	Попытка
		СчетОбъект.Записать();
	Исключение
		ТекстСообщения = НСтр("ru = 'Не удалось установить код быстрого выбора
			|для счета 19.10 ""НДС, уплачиваемый при импорте из Таможенного союза"", 
			|рекомендуется установить самостоятельно.
			|
			|%1'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ТекстСообщения, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Обновление информационной базы'"), УровеньЖурналаРегистрации.Ошибка,,, ТекстСообщения);
	КонецПопытки;
	
	СчетОбъект = ПланыСчетов.Хозрасчетный.НДСТаможенныйСоюзКУплате.ПолучитьОбъект();
	СчетОбъект.КодБыстрогоВыбора = "6842";
	
	Попытка
		СчетОбъект.Записать();
	Исключение
		ТекстСообщения = НСтр("ru = 'Не удалось установить код быстрого выбора
			|для счета 68.42 ""НДС при импорте товаров из Таможенного союза"", 
			|рекомендуется установить самостоятельно.
			|
			|%1'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ТекстСообщения, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Обновление информационной базы'"), УровеньЖурналаРегистрации.Ошибка,,, ТекстСообщения);
	КонецПопытки;
	
КонецПроцедуры

// Обработка переименования счета 68.12
//
Процедура ПереименоватьСчетНалогаУСН() Экспорт

	Если ПланыОбмена.ГлавныйУзел() <> Неопределено Тогда // В подчиненных узлах РИБ не выполняется
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Попытка
	
		СчетСсылка = ПланыСчетов.Хозрасчетный.ЕНприУСН;

		РеквизитыСчета = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(СчетСсылка,
			"Код, Наименование, ЗапретитьИспользоватьВПроводках, Забалансовый");
			
		Если НЕ РеквизитыСчета.ЗапретитьИспользоватьВПроводках
			И НЕ РеквизитыСчета.Забалансовый
			И РеквизитыСчета.Код = "68.12"
			И СокрЛП(РеквизитыСчета.Наименование) = НСтр("ru = 'Единый налог при применении упрощенной системы налогообложения'") Тогда

			// Счет не модифицировался пользователем
			// Можно менять наименование
			
			СчетОбъект = СчетСсылка.ПолучитьОбъект();
			СчетОбъект.Наименование = НСтр("ru = 'Налог при упрощенной системе налогообложения'");
			
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(СчетОбъект, Истина);
		
		КонецЕсли;
		
	Исключение
		ТекстСообщения = НСтр("ru = 'Не удалось установить новое наименование
			|для счета 68.12 ""Единый налог при применении упрощенной системы налогообложения"".
			|
			|%1'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ТекстСообщения, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Обновление информационной базы'"), УровеньЖурналаРегистрации.Ошибка,,, ТекстСообщения);
	КонецПопытки;

КонецПроцедуры

// Приводит признак УчетПоПодразделениям на счетах учета затрат в соответствие с переданным параметром.
// Если установить признак на одном из счетов не удалось, то вызывает исключение. 
// При этом отменяет транзакцию, начатую методом НачатьТранзакцию().
// Не следует вызывать из транзакций, которые не могут быть отменены.
//
// Также приводит в соответствие признаку 
//
// Параметры:
//  ВестиУчетЗатратПоПодразделениям	 - Булево - значение, к которому следует привести свойства счетов
//
Процедура УстановитьУчетЗатратПоПодразделениям(ВестиУчетЗатратПоПодразделениям, СобытиеЖурналаРегистрации) Экспорт
	
	Если ВестиУчетЗатратПоПодразделениям Тогда
		
		// на языке пользователя
		ШаблонСообщенияОбОшибкеКратко = НСтр("ru = 'Ошибка при включении учета по подразделениям на счете %1
		|Подробности см. в Журнале регистрации.'"); 
		
		// на языке администратора - для записи в журнал регистрации
		ШаблонСообщенияОбОшибкеДетально = НСтр("ru = 'Ошибка при включении учета по подразделениям на счете %1:
			|%2'",
			ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()); 
		
		ШаблонСообщенияОбУспехе = НСтр("ru = 'На счете %1 включен учет по подразделениям'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
		
	Иначе
		
		ШаблонСообщенияОбОшибкеКратко = НСтр("ru = 'Ошибка при отключении учета по подразделениям на счете %1
		|Подробности см. в Журнале регистрации.'");
		
		ШаблонСообщенияОбОшибкеДетально = НСтр("ru = 'Ошибка при отключении учета по подразделениям на счете %1:
			|%2'",
			ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
		
		ШаблонСообщенияОбУспехе = НСтр("ru = 'На счете %1 отключен учет по подразделениям'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
		
	КонецЕсли;
	
	МетаданныеПланСчетов = Метаданные.ПланыСчетов.Хозрасчетный; // Для записи в журнал регистрации
	
	Для Каждого Счет Из БухгалтерскийУчетПереопределяемый.СчетаУчетаЗатратПоПодразделениям() Цикл
		
		Объект = Счет.ПолучитьОбъект();
		Если Объект.УчетПоПодразделениям = ВестиУчетЗатратПоПодразделениям Тогда
			Продолжить;
		КонецЕсли;
		
		Объект.УчетПоПодразделениям = ВестиУчетЗатратПоПодразделениям;
		
		Попытка
			Объект.Записать();
		Исключение
			
			ОписаниеОшибки = ИнформацияОбОшибке();
			
			Если ТранзакцияАктивна() Тогда
				ОтменитьТранзакцию();
			КонецЕсли;
			
			// В журнал регистрации выведем подробную информацию
			ТекстСообщенияОбОшибке = СтрШаблон(
				ШаблонСообщенияОбОшибкеДетально,
				Объект.Код,
				ПодробноеПредставлениеОшибки(ОписаниеОшибки));
				
			ЗаписьЖурналаРегистрации(
				СобытиеЖурналаРегистрации,
				УровеньЖурналаРегистрации.Ошибка,
				МетаданныеПланСчетов,
				Счет, // Данные
				ТекстСообщенияОбОшибке);
				
			// Для пользователя выведем краткое сообщение
			ВызватьИсключение СтрШаблон(ШаблонСообщенияОбОшибкеКратко, Объект.Код);
				
		КонецПопытки;
			
		// Запишем в журнал регистрации подробную информацию об изменениях
		ЗаписьЖурналаРегистрации(
			СобытиеЖурналаРегистрации,
			УровеньЖурналаРегистрации.Информация, 
			МетаданныеПланСчетов,
			Счет, // Данные
			СтрШаблон(ШаблонСообщенияОбУспехе, Объект.Код),
			РежимТранзакцииЗаписиЖурналаРегистрации.Транзакционная);
		
	КонецЦикла;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБНОВЛЕНИЯ

Процедура ОбновитьПараметрыСчета96_09() Экспорт
	
	СчетОбъект = ПланыСчетов.Хозрасчетный.РезервыПредстоящихРасходовПрочие.ПолучитьОбъект();
	СчетОбъект.Родитель = ПланыСчетов.Хозрасчетный.РезервыПредстоящихРасходов;
	СчетОбъект.КодБыстрогоВыбора = СокрЛП(СтрЗаменить(СчетОбъект.Код, ".", ""));
	ОбновлениеИнформационнойБазы.ЗаписатьДанные(СчетОбъект);
	
КонецПроцедуры

Процедура ОбработатьДобавлениеСчетовУчетаЛизинг() Экспорт
	
	Если ПланыОбмена.ГлавныйУзел() <> Неопределено Тогда // В подчиненных узлах РИБ не выполняется
		Возврат;
	КонецЕсли;
	
	МассивНовыхСчетов = Новый Массив;
	МассивНовыхСчетов.Добавить(ПланыСчетов.Хозрасчетный.АрендованноеИмущество);             // 01.03
	МассивНовыхСчетов.Добавить(ПланыСчетов.Хозрасчетный.АмортизацияАрендованногоИмущества); // 02.03
	МассивНовыхСчетов.Добавить(ПланыСчетов.Хозрасчетный.РасчетыПоАренде);                   // 76.07
	МассивНовыхСчетов.Добавить(ПланыСчетов.Хозрасчетный.АрендныеОбязательства);             // 76.07.1
	МассивНовыхСчетов.Добавить(ПланыСчетов.Хозрасчетный.ЛизинговыеПлатежи);                 // 76.07.2
	МассивНовыхСчетов.Добавить(ПланыСчетов.Хозрасчетный.НДСпоАренднымОбязательствам);       // 76.07.9
	МассивНовыхСчетов.Добавить(ПланыСчетов.Хозрасчетный.РасчетыПоАрендеВал);                // 76.27
	МассивНовыхСчетов.Добавить(ПланыСчетов.Хозрасчетный.АрендныеОбязательстваВал);          // 76.27.1
	МассивНовыхСчетов.Добавить(ПланыСчетов.Хозрасчетный.ЛизинговыеПлатежиВал);              // 76.27.2
	МассивНовыхСчетов.Добавить(ПланыСчетов.Хозрасчетный.РасчетыПоАрендеУЕ);                 // 76.37
	МассивНовыхСчетов.Добавить(ПланыСчетов.Хозрасчетный.АрендныеОбязательстваУЕ);           // 76.37.1
	МассивНовыхСчетов.Добавить(ПланыСчетов.Хозрасчетный.ЛизинговыеПлатежиУЕ);               // 76.37.2
	МассивНовыхСчетов.Добавить(ПланыСчетов.Хозрасчетный.НДСпоАренднымОбязательствамУЕ);     // 76.37.9
	
	МассивСчетовГрупп = Новый Массив;
	МассивСчетовГрупп.Добавить(ПланыСчетов.Хозрасчетный.РасчетыПоАренде);    // 76.07
	МассивСчетовГрупп.Добавить(ПланыСчетов.Хозрасчетный.РасчетыПоАрендеВал); // 76.27
	МассивСчетовГрупп.Добавить(ПланыСчетов.Хозрасчетный.РасчетыПоАрендеУЕ);  // 76.37

	МассивСчетовССубконто3 = Новый Массив;
	МассивСчетовССубконто3.Добавить(ПланыСчетов.Хозрасчетный.ЛизинговыеПлатежи);    // 76.07.2
	МассивСчетовССубконто3.Добавить(ПланыСчетов.Хозрасчетный.ЛизинговыеПлатежиВал); // 76.27.2
	МассивСчетовССубконто3.Добавить(ПланыСчетов.Хозрасчетный.ЛизинговыеПлатежиУЕ);  // 76.37.2
	
	Для Каждого Счет Из МассивНовыхСчетов Цикл
	
		Попытка
			СчетОбъект = Счет.ПолучитьОбъект();
			СчетОбъект.КодБыстрогоВыбора = СокрЛП(СтрЗаменить(СчетОбъект.Код, ".", ""));
			
			Если МассивСчетовГрупп.Найти(Счет) <> Неопределено Тогда
				СчетОбъект.ЗапретитьИспользоватьВПроводках = Истина;
			КонецЕсли;
			
			Если МассивСчетовССубконто3.Найти(Счет) <> Неопределено Тогда
			
				Субконто      = СчетОбъект.ВидыСубконто.Найти(
					ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.ДокументыРасчетовСКонтрагентами, "ВидСубконто");
				НетДокументов = (Субконто = Неопределено);
				ВсегоСубконто = СчетОбъект.ВидыСубконто.Количество();
				Если НетДокументов И ВсегоСубконто < 3 Тогда
					
					НовыйВид = СчетОбъект.ВидыСубконто.Добавить();
					
					НовыйВид.ВидСубконто    = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.ДокументыРасчетовСКонтрагентами;
					НовыйВид.Суммовой       = Истина;
					НовыйВид.Валютный       = Истина;
					НовыйВид.Количественный = Истина;
					
				КонецЕсли;
				
			КонецЕсли;
			
			СчетОбъект.Записать();
		Исключение
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Обновление информационной базы'"), УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		КонецПопытки;
	
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаменитьУдаленныйСчет01_К() Экспорт
	
	УдаленныйСчет = ПланыСчетов.Хозрасчетный.УдалитьКорректировкаСтоимостиАрендованногоИмущества;
	СчетОбъект = УдаленныйСчет.ПолучитьОбъект();
	СчетОбъект.КодБыстрогоВыбора = СокрЛП(СтрЗаменить(СчетОбъект.Код, ".", ""));
	
	Попытка
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(СчетОбъект);
	Исключение
		ШаблонСообщения = НСтр("ru = 'Не удалось установить код быстрого выбора по счету
                               |%1'");
		ТекстСообщения = СтрШаблон(ШаблонСообщения, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		
		ЗаписьЖурналаРегистрации(
			ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), 
			УровеньЖурналаРегистрации.Ошибка,
			Метаданные.ПланыСчетов.Хозрасчетный,
			СчетОбъект.Ссылка, 
			ТекстСообщения);
	КонецПопытки;
	
	НовыйСчет = ПланыСчетов.Хозрасчетный.КорректировкаСтоимостиАрендованногоИмущества;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Счет", УдаленныйСчет);
	
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Хозрасчетный.Регистратор
	|ИЗ
	|	РегистрБухгалтерии.Хозрасчетный КАК Хозрасчетный
	|ГДЕ
	|	(Хозрасчетный.СчетДт = &Счет
	|			ИЛИ Хозрасчетный.СчетКт = &Счет)";
	
	Результат = Запрос.Выполнить();
	Рег = РегистрыБухгалтерии.Хозрасчетный;
	
	Проводки = Рег.СоздатьНаборЗаписей();
	
	ВыборкаДетальныеЗаписи = Результат.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ТекДок = ВыборкаДетальныеЗаписи.Регистратор;
		Если ЗначениеЗаполнено(ТекДок) Тогда
	
			Проводки.Отбор.Регистратор.Значение = ТекДок;
			Проводки.Прочитать();
	
			Для Каждого Проводка ИЗ Проводки Цикл
				Если Проводка.СчетДт = УдаленныйСчет Тогда
					Проводка.СчетДт = НовыйСчет;
				КонецЕсли;
				Если Проводка.СчетКт = УдаленныйСчет Тогда
					Проводка.СчетКт = НовыйСчет;
				КонецЕсли;
			КонецЦикла;
	
		Попытка
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(Проводки);
		Исключение
			ШаблонСообщения = НСтр("ru = 'Не удалось обновить проводки по документу
                                   |%1'");
			ТекстСообщения = СтрШаблон(ШаблонСообщения, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			ЗаписьЖурналаРегистрации(
				ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), 
				УровеньЖурналаРегистрации.Ошибка,
				ТекДок.Метаданные(),
				ТекДок, 
				ТекстСообщения);
		КонецПопытки;
		
		КонецЕсли;
	
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаменитьСчетПФР_ОПС_ИП() Экспорт
	
	СчетУчетаУдаленный = ПланыСчетов.Хозрасчетный.УдалитьПФР_ОПС_ИП;
	СчетУчетаНовый     = ПланыСчетов.Хозрасчетный.ПФР_ОПС_ИП;
	
	СчетОбъектУдаленный = СчетУчетаУдаленный.ПолучитьОбъект();
	СчетОбъектУдаленный.КодБыстрогоВыбора = "";
	ОбновлениеИнформационнойБазы.ЗаписатьОбъект(СчетОбъектУдаленный);
	
	НомерВидыПлатежейВГосБюджет_Удаленный = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.НомерСубконто(
		СчетУчетаУдаленный, ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.ВидыПлатежейВГосБюджет);
	НомерВидыПлатежейВГосБюджет_Новый = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.НомерСубконто(
		СчетУчетаНовый, ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.ВидыПлатежейВГосБюджет);
	
	Если НомерВидыПлатежейВГосБюджет_Удаленный = 0 Или НомерВидыПлатежейВГосБюджет_Новый = 0 Тогда
		Возврат;
	КонецЕсли;
	
	НомерВидыСтраховыхВзносовИП = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.НомерСубконто(
		СчетУчетаУдаленный, ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.УдалитьВидыСтраховыхВзносовИП);
	
	Документы.СписаниеСРасчетногоСчета.ЗаменитьСчетПФР_ОПС_ИП();
	Документы.РасходныйКассовыйОрдер.ЗаменитьСчетПФР_ОПС_ИП();
	Документы.ВводНачальныхОстатков.ЗаменитьСчетПФР_ОПС_ИП();
	
	РегистрыНакопления.ПрочиеРасчеты.ЗаменитьСчетПФР_ОПС_ИП();
	РегистрыНакопления.ИППрочиеРасходы.ЗаменитьСчетПФР_ОПС_ИП();
	РегистрыНакопления.РасходыПриУСН.ЗаменитьСчетПФР_ОПС_ИП();
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("СчетУчетаУдаленный", СчетУчетаУдаленный);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Хозрасчетный.Регистратор КАК Регистратор
	|ИЗ
	|	РегистрБухгалтерии.Хозрасчетный КАК Хозрасчетный
	|ГДЕ
	|	Хозрасчетный.СчетДт = &СчетУчетаУдаленный
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	Хозрасчетный.Регистратор
	|ИЗ
	|	РегистрБухгалтерии.Хозрасчетный КАК Хозрасчетный
	|ГДЕ
	|	Хозрасчетный.СчетКт = &СчетУчетаУдаленный";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		НаборЗаписей = РегистрыБухгалтерии.Хозрасчетный.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Регистратор.Значение = Выборка.Регистратор;
		НаборЗаписей.Прочитать();
		
		Для Каждого Запись Из НаборЗаписей Цикл
			Если Запись.СчетДт = СчетУчетаУдаленный Тогда
				ЗаменитьСчетПФР_ОПС_ИПвПроводке(Запись, "СчетДт", "СубконтоДт");
			КонецЕсли;
			Если Запись.СчетКт = СчетУчетаУдаленный Тогда
				ЗаменитьСчетПФР_ОПС_ИПвПроводке(Запись, "СчетКт", "СубконтоКт");
			КонецЕсли;
		КонецЦикла;
		
		ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписей);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаменитьСчетПФР_ОПС_ИПвДокументе(Объект, ИмяСчетаУчета, ИмяСубконто) Экспорт
	
	НомерВидыПлатежейВГосБюджет_Удаленный = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.НомерСубконто(
		Объект[ИмяСчетаУчета], ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.ВидыПлатежейВГосБюджет);
	НомерВидыСтраховыхВзносовИП_Удаленный = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.НомерСубконто(
		Объект[ИмяСчетаУчета], ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.УдалитьВидыСтраховыхВзносовИП);
	
	Если НомерВидыПлатежейВГосБюджет_Удаленный <> 0 Тогда
		ВидПлатежаВГосБюджет = Объект[ИмяСубконто + НомерВидыПлатежейВГосБюджет_Удаленный];
	КонецЕсли;
	
	Если НомерВидыСтраховыхВзносовИП_Удаленный <> 0 Тогда
		
		Если ВидПлатежаВГосБюджет = Перечисления.ВидыПлатежейВГосБюджет.Налог Тогда
			ВидСтраховогоВзносаИП = Объект[ИмяСубконто + НомерВидыСтраховыхВзносовИП_Удаленный];
			Если ВидСтраховогоВзносаИП = Перечисления.УдалитьВидыСтраховыхВзносовИП.СтраховыеВзносыСДоходов Тогда
				ВидПлатежаВГосБюджет = Перечисления.ВидыПлатежейВГосБюджет.ВзносыСвышеПредела;
			КонецЕсли;
		КонецЕсли;
		
		Объект[ИмяСубконто + НомерВидыСтраховыхВзносовИП_Удаленный] = Неопределено;
		
	КонецЕсли;
	
	СчетУчетаНовый = ПланыСчетов.Хозрасчетный.ПФР_ОПС_ИП;
	
	Объект[ИмяСчетаУчета] = СчетУчетаНовый;
	
	НомерВидыПлатежейВГосБюджет_Новый = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.НомерСубконто(
		СчетУчетаНовый, ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.ВидыПлатежейВГосБюджет);
	Если НомерВидыПлатежейВГосБюджет_Новый <> 0 Тогда
		Объект[ИмяСубконто + НомерВидыПлатежейВГосБюджет_Новый] = ВидПлатежаВГосБюджет;
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаменитьСчетПФР_ОПС_ИПвПроводке(Проводка, ИмяСчетаУчета, ИмяСубконто)
	
	КоллекцияСубконто = Проводка[ИмяСубконто];
	
	ВидПлатежаВГосБюджет = КоллекцияСубконто[ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.ВидыПлатежейВГосБюджет];
	
	Если ВидПлатежаВГосБюджет = Перечисления.ВидыПлатежейВГосБюджет.Налог Тогда
		ВидСтраховогоВзносаИП = КоллекцияСубконто[ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.УдалитьВидыСтраховыхВзносовИП];
		Если ВидСтраховогоВзносаИП = Перечисления.УдалитьВидыСтраховыхВзносовИП.СтраховыеВзносыСДоходов Тогда
			ВидПлатежаВГосБюджет = Перечисления.ВидыПлатежейВГосБюджет.ВзносыСвышеПредела;
		КонецЕсли;
	КонецЕсли;
	
	Проводка[ИмяСчетаУчета] = ПланыСчетов.Хозрасчетный.ПФР_ОПС_ИП;
	
	КоллекцияСубконто.Очистить();
	КоллекцияСубконто.Вставить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.ВидыПлатежейВГосБюджет, ВидПлатежаВГосБюджет);
	
КонецПроцедуры

Процедура ОбновитьПараметрыСчета01_К() Экспорт
	
	СчетОбъект = ПланыСчетов.Хозрасчетный.КорректировкаСтоимостиАрендованногоИмущества.ПолучитьОбъект();
	СчетОбъект.КодБыстрогоВыбора = СокрЛП(СтрЗаменить(СчетОбъект.Код, ".", ""));
	
	Попытка
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(СчетОбъект);
	Исключение
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Обновление информационной базы'"), 
			УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
КонецПроцедуры

#КонецЕсли