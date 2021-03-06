﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.Печать
	
	Если Параметры.Ключ.Пустая() Тогда
		// Это новый счет, проверим, заполнен ли родитель для него.
		// Если родитель заполнен, то правило редактирования определяется по родителю
		Если ЗначениеЗаполнено(Объект.Родитель) Тогда
			ЗапрещенныйСчет      = ЭтоЗапрещенныйСчет(Объект.Родитель);
		КонецЕсли;
	Иначе
		ЗапрещенныйСчет      = ЭтоЗапрещенныйСчет(Объект.Ссылка);
	КонецЕсли;
	
	Если Параметры.Ключ.Пустая() 
		И Параметры.ЗначениеКопирования.Пустая() Тогда
		Объект.Валютный       = Ложь;
		Объект.Количественный = Ложь;
	КонецЕсли;
	
	ВидыСубконтоЗапрещенногоСчета.Параметры.УстановитьЗначениеПараметра("Ссылка", Объект.Ссылка);
	
	УстановитьДоступностьРедактированияВидовСубконто(НЕ ЗапрещенныйСчет);
	
	Элементы.Родитель.ТолькоПросмотр = Объект.Предопределенный;
	
	Элементы.Вид.Доступность            = НЕ Объект.Предопределенный;
	Элементы.Забалансовый.Доступность   = НЕ Объект.Предопределенный;
	Элементы.Количественный.Доступность = НЕ Объект.Предопределенный;
	Элементы.Валютный.Доступность       = НЕ Объект.Предопределенный;
	Элементы.НалоговыйУчет.Доступность  = НЕ Объект.Предопределенный;
	Элементы.УчетПоПодразделениям.Доступность = НЕ Объект.Предопределенный;
	
	УправлениеФормой(ЭтаФорма);
	
	УстановитьУсловноеОформление();	
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	ОбновитьПовторноИспользуемыеЗначения();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КодПриИзменении(Элемент)
	
	Объект.Код = СтрЗаменить(Объект.Код, " ", "");
	Пока Прав(Объект.Код, 1) = "." Цикл
		Объект.Код = Лев(Объект.Код, СтрДлина(Объект.Код)-1);
	КонецЦикла;
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Возврат;
	КонецЕсли;
	
	// Если задан субсчет, то в его коде должна быть точка
	Код      = Объект.Код;
	Родитель = Объект.Родитель;
	
	Если СтрНайти(Код, ".") > 0 Тогда
		
		//Найдем код родителя, для этого найдем последнюю точку в коде счета
		ПозицияТочки = СтрДлина(Код);
		
		Пока Сред(Код, ПозицияТочки, 1) <> "." Цикл
			
			ПозицияТочки = ПозицияТочки - 1;
			
		КонецЦикла;
		
		КодРодителя    = Лев(Код, ПозицияТочки - 1);
		РодительПоКоду = НайтиРодителя(КодРодителя);
		
		Если НЕ ЗначениеЗаполнено(РодительПоКоду) Тогда
			
			ПоказатьПредупреждение( , СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='План счетов не содержит счета с кодом %1'"),
				КодРодителя));
			
		ИначеЕсли РодительПоКоду <> Объект.Ссылка Тогда
			
			Объект.Родитель       = РодительПоКоду;
			
			РодительПриИзмененииНаСервере();
			
		КонецЕсли;
		
	КонецЕсли;
	
	Объект.КодБыстрогоВыбора = СокрЛП(СтрЗаменить(Код, ".", ""));
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура РодительПриИзменении(Элемент)
	
	РодительПриИзмененииНаСервере();
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура РодительПриИзмененииНаСервере()
	
	Если ЗначениеЗаполнено(Объект.Родитель) Тогда
		
		// Определяем запрещенность редактирования по родителю
		// Если родитель - запрещенный счет, значит и текущий также будет запрещенным,
		// так как при определении запрещенности счета в запросе используется ВИерархии
		// Если счет запрещенный, то принудительно копируем состав субконто из родителя и устанавливаем свойство ЗапрещенныйСчет
		ЗапрещенныйСчет = ЭтоЗапрещенныйСчет(Объект.Родитель);
		Если ЗапрещенныйСчет Тогда
			
			// Скопируем свойства счета
			СвойстваСчета = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.Родитель, "Забалансовый, Валютный, Количественный, УчетПоПодразделениям, НалоговыйУчет, Вид");
			ЗаполнитьЗначенияСвойств(Объект, СвойстваСчета);
			
			//скопируем аналитику счета
			Запрос = Новый Запрос();
			Запрос.Параметры.Вставить("Счет", Объект.Родитель);
			Запрос.Текст =
			"ВЫБРАТЬ
			|	ХозрасчетныйВидыСубконто.ВидСубконто КАК ВидСубконто,
			|	ХозрасчетныйВидыСубконто.НомерСтроки КАК ПорядокСубконто,
			|	ХозрасчетныйВидыСубконто.ТолькоОбороты,
			|	ХозрасчетныйВидыСубконто.Суммовой,
			|	ХозрасчетныйВидыСубконто.Валютный,
			|	ХозрасчетныйВидыСубконто.Количественный
			|ИЗ
			|	ПланСчетов.Хозрасчетный.ВидыСубконто КАК ХозрасчетныйВидыСубконто
			|ГДЕ
			|	ХозрасчетныйВидыСубконто.Ссылка = &Счет
			|
			|УПОРЯДОЧИТЬ ПО
			|	ХозрасчетныйВидыСубконто.НомерСтроки";
			
			ЭталонныеСубконта = Запрос.Выполнить().Выгрузить();
			МассивСубконтоКУдалению = Новый Массив;
			// Удаляем лишние виды субконто
			Для К = 0 По Объект.ВидыСубконто.Количество()-1 Цикл
				ВидСубконто = Объект.ВидыСубконто[К].ВидСубконто;
				Если ЭталонныеСубконта.Найти(ВидСубконто, "ВидСубконто") = Неопределено Тогда
					МассивСубконтоКУдалению.Добавить(ВидСубконто);
				КонецЕсли;
			КонецЦикла;
			
			Для Каждого СубконтоКУдалению Из МассивСубконтоКУдалению Цикл
				СтрокиКУдалению = Объект.ВидыСубконто.НайтиСтроки(Новый Структура("ВидСубконто", СубконтоКУдалению));
				Для Каждого СтрокаКУдалению ИЗ СтрокиКУдалению Цикл
					Объект.ВидыСубконто.Удалить(СтрокаКУдалению);
				КонецЦикла;
			КонецЦикла;
			
			// Установим свойства субконто так, как они установлены у родителя
			Для Каждого ЭталонноеСубконто ИЗ ЭталонныеСубконта Цикл
				СуществующееСубконто = Объект.ВидыСубконто.НайтиСтроки(Новый Структура("ВидСубконто", ЭталонноеСубконто.ВидСубконто));
				Если СуществующееСубконто.Количество()>0 Тогда
					ЗаполнитьЗначенияСвойств(СуществующееСубконто[0], ЭталонноеСубконто);
					ИндексСубконто = Объект.ВидыСубконто.Индекс(СуществующееСубконто[0]);
					Объект.ВидыСубконто.Сдвинуть(ИндексСубконто, ЭталонноеСубконто.ПорядокСубконто - 1 - ИндексСубконто);
				Иначе
					ЗаполнитьЗначенияСвойств(Объект.ВидыСубконто.Вставить(ЭталонноеСубконто.ПорядокСубконто-1), ЭталонноеСубконто);
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЕсли;
		
	Иначе
		// Такая ситуация может возникнуть в том случае,
		// Если родитель счета не выбран
		// В этом случае никаких органичений быть не может
		ЗапрещенныйСчет = Ложь;
	КонецЕсли;
	
	УстановитьДоступностьРедактированияВидовСубконто(НЕ ЗапрещенныйСчет);
	
КонецПроцедуры

&НаКлиенте
Процедура ВалютныйПриИзменении(Элемент)
	
	Элементы.ВидыСубконтоВалютный.Видимость = Объект.Валютный;
	
КонецПроцедуры

&НаКлиенте
Процедура КоличественныйПриИзменении(Элемент)
	
	Элементы.ВидыСубконтоКоличественный.Видимость = Объект.Количественный;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыВидыСубконто

&НаКлиенте
Процедура ВидыСубконтоПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Если ЗапрещенныйСчет Тогда
		ПредупреждениеОНевозможностиИзмененияСоставаВидовСубконто(Отказ);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидыСубконтоПередНачаломИзменения(Элемент, Отказ)
	
	Если ЗапрещенныйСчет Тогда
		ПредупреждениеОНевозможностиИзмененияСоставаВидовСубконто(Отказ);
	КонецЕсли;
	
	Если Элемент.ТекущиеДанные.Предопределенное Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидыСубконтоПередУдалением(Элемент, Отказ)
	
	Если ЗапрещенныйСчет Тогда
		ПредупреждениеОНевозможностиИзмененияСоставаВидовСубконто(Отказ);
	КонецЕсли;
	
	Если Элемент.ТекущиеДанные.Предопределенное Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидыСубконтоПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		Элемент.ТекущиеДанные.Суммовой       = Истина;
		Элемент.ТекущиеДанные.Валютный       = Истина;
		Элемент.ТекущиеДанные.Количественный = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();


	// ВидыСубконтоВалютный

	ЭлементУО = УсловноеОформление.Элементы.Добавить();

	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ВидыСубконтоВалютный");

	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Объект.Валютный", ВидСравненияКомпоновкиДанных.Равно, Ложь);

	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);


	// ВидыСубконтоКоличественный

	ЭлементУО = УсловноеОформление.Элементы.Добавить();

	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ВидыСубконтоКоличественный");

	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Объект.Количественный", ВидСравненияКомпоновкиДанных.Равно, Ложь);

	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);

КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьПараметрыСчета(Счет)
	
	ПараметрыСчета = Новый Структура;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЕСТЬNULL(МАКСИМУМ(Хозрасчетный.УчетПоПодразделениям), ЛОЖЬ) КАК УчетПоПодразделениям,
	|	ЕСТЬNULL(МАКСИМУМ(Хозрасчетный.НалоговыйУчет), ЛОЖЬ) КАК НалоговыйУчет
	|ИЗ
	|	ПланСчетов.Хозрасчетный КАК Хозрасчетный
	|ГДЕ
	|	Хозрасчетный.Родитель В ИЕРАРХИИ(&Родитель)";
	Запрос.УстановитьПараметр("Родитель", Счет);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		ПараметрыСчета.Вставить("УчетПоПодразделениям", Истина);
		ПараметрыСчета.Вставить("НалоговыйУчет"       , Истина);
	Иначе
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		ПараметрыСчета.Вставить("УчетПоПодразделениям", НЕ Выборка.УчетПоПодразделениям);
		ПараметрыСчета.Вставить("НалоговыйУчет"       , НЕ Выборка.НалоговыйУчет);
	КонецЕсли;
	
	Возврат ПараметрыСчета;
	
КонецФункции

&НаСервереБезКонтекста
Функция НайтиРодителя(КодРодителя)
	
	Возврат ПланыСчетов.Хозрасчетный.НайтиПоКоду(КодРодителя);
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьЗапрещенныеСчета()
	
	ЗапрещенныеСчета = Новый Массив;
	ЗапрещенныеСчета.Добавить(ПланыСчетов.Хозрасчетный.ОборудованиеКУстановке);              // 07
	ЗапрещенныеСчета.Добавить(ПланыСчетов.Хозрасчетный.ПриобретениеОбъектовОсновныхСредств); // 08.04
	ЗапрещенныеСчета.Добавить(ПланыСчетов.Хозрасчетный.Товары);                              // 41
	ЗапрещенныеСчета.Добавить(ПланыСчетов.Хозрасчетный.ГотоваяПродукция);                    // 43
	ЗапрещенныеСчета.Добавить(ПланыСчетов.Хозрасчетный.Материалы);                           // 10
	ЗапрещенныеСчета.Добавить(ПланыСчетов.Хозрасчетный.ТоварыОтгруженные);                   // 45
	ЗапрещенныеСчета.Добавить(ПланыСчетов.Хозрасчетный.ТоварыПринятыеНаКомиссию);            // 004
	ЗапрещенныеСчета.Добавить(ПланыСчетов.Хозрасчетный.РасчетыСПерсоналомПоОплатеТруда);     // 70
	ЗапрещенныеСчета.Добавить(ПланыСчетов.Хозрасчетный.РасчетыПоДепонированнымСуммам);       // 76.04
	ЗапрещенныеСчета.Добавить(ПланыСчетов.Хозрасчетный.РасходыНаОплатуТрудаБудущихПериодов); // 97.01
	ЗапрещенныеСчета.Добавить(ПланыСчетов.Хозрасчетный.Касса);                               // 50
	ЗапрещенныеСчета.Добавить(ПланыСчетов.Хозрасчетный.КассаОрганизации);                    // 50.01
	ЗапрещенныеСчета.Добавить(ПланыСчетов.Хозрасчетный.ОперационнаяКасса);                   // 50.02
	ЗапрещенныеСчета.Добавить(ПланыСчетов.Хозрасчетный.КассаОрганизацииВал);                 // 50.21
	ЗапрещенныеСчета.Добавить(ПланыСчетов.Хозрасчетный.РасчетныеСчета);                      // 51
	ЗапрещенныеСчета.Добавить(ПланыСчетов.Хозрасчетный.ВалютныеСчета);                       // 52
	ЗапрещенныеСчета.Добавить(ПланыСчетов.Хозрасчетный.СпециальныеСчета);                    // 55
	ЗапрещенныеСчета.Добавить(ПланыСчетов.Хозрасчетный.Аккредитивы);                         // 55.01
	ЗапрещенныеСчета.Добавить(ПланыСчетов.Хозрасчетный.ЧековыеКнижки);                       // 55.02
	ЗапрещенныеСчета.Добавить(ПланыСчетов.Хозрасчетный.ДепозитныеСчета);                     // 55.03
	ЗапрещенныеСчета.Добавить(ПланыСчетов.Хозрасчетный.ПрочиеСпециальныеСчета);              // 55.04
	ЗапрещенныеСчета.Добавить(ПланыСчетов.Хозрасчетный.АккредитивыВал);                      // 55.21
	ЗапрещенныеСчета.Добавить(ПланыСчетов.Хозрасчетный.ДепозитныеСчетаВал);                  // 55.23
	ЗапрещенныеСчета.Добавить(ПланыСчетов.Хозрасчетный.ПрочиеСпециальныеСчетаВал);           // 55.24
	ЗапрещенныеСчета.Добавить(ПланыСчетов.Хозрасчетный.ПереводыВПути);                       // 57.01
	ЗапрещенныеСчета.Добавить(ПланыСчетов.Хозрасчетный.ПереводыВПутиВал);                    // 57.21
	
	Возврат Новый ФиксированныйМассив(ЗапрещенныеСчета);
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьСсылкуНастройкиСубконто(Счет)
	
	УчетЗапасов = Новый Структура("ИмяФормы, ЗаголовокФормы", "УчетЗапасов", НСтр("ru='Учет запасов'")); 
	УчетРасчетовСПерсоналом = Новый Структура("ИмяФормы, ЗаголовокФормы", "УчетРасчетовСПерсоналом", НСтр("ru='Учет расчетов с персоналом'")); 
	УчетДвиженияДенежныхСредств = Новый Структура("ИмяФормы, ЗаголовокФормы", "УчетДвиженияДенежныхСредств", НСтр("ru='Учет движения денежных средств'")); 
	
	СтруктураФорм = Новый Соответствие;
	СтруктураФорм.Вставить(ПланыСчетов.Хозрасчетный.ОборудованиеКУстановке,              УчетЗапасов);                 // 07
	СтруктураФорм.Вставить(ПланыСчетов.Хозрасчетный.ПриобретениеОбъектовОсновныхСредств, УчетЗапасов);                 // 08.04
	СтруктураФорм.Вставить(ПланыСчетов.Хозрасчетный.Товары,                              УчетЗапасов);                 // 41
	СтруктураФорм.Вставить(ПланыСчетов.Хозрасчетный.ГотоваяПродукция,                    УчетЗапасов);                 // 43
	СтруктураФорм.Вставить(ПланыСчетов.Хозрасчетный.Материалы,                           УчетЗапасов);                 // 10
	СтруктураФорм.Вставить(ПланыСчетов.Хозрасчетный.ТоварыОтгруженные,                   УчетЗапасов);                 // 45
	СтруктураФорм.Вставить(ПланыСчетов.Хозрасчетный.ТоварыПринятыеНаКомиссию,            УчетЗапасов);                 // 004
	СтруктураФорм.Вставить(ПланыСчетов.Хозрасчетный.РасчетыСПерсоналомПоОплатеТруда,     УчетРасчетовСПерсоналом);     // 70
	СтруктураФорм.Вставить(ПланыСчетов.Хозрасчетный.РасчетыПоДепонированнымСуммам,       УчетРасчетовСПерсоналом);     // 76.04
	СтруктураФорм.Вставить(ПланыСчетов.Хозрасчетный.РасходыНаОплатуТрудаБудущихПериодов, УчетРасчетовСПерсоналом);     // 97.01
	СтруктураФорм.Вставить(ПланыСчетов.Хозрасчетный.Касса,                               УчетДвиженияДенежныхСредств); // 50
	СтруктураФорм.Вставить(ПланыСчетов.Хозрасчетный.КассаОрганизации,                    УчетДвиженияДенежныхСредств); // 50.01
	СтруктураФорм.Вставить(ПланыСчетов.Хозрасчетный.ОперационнаяКасса,                   УчетДвиженияДенежныхСредств); // 50.02
	СтруктураФорм.Вставить(ПланыСчетов.Хозрасчетный.КассаОрганизацииВал,                 УчетДвиженияДенежныхСредств); // 50.21
	СтруктураФорм.Вставить(ПланыСчетов.Хозрасчетный.РасчетныеСчета,                      УчетДвиженияДенежныхСредств); // 51
	СтруктураФорм.Вставить(ПланыСчетов.Хозрасчетный.ВалютныеСчета,                       УчетДвиженияДенежныхСредств); // 52
	СтруктураФорм.Вставить(ПланыСчетов.Хозрасчетный.СпециальныеСчета,                    УчетДвиженияДенежныхСредств); // 55
	СтруктураФорм.Вставить(ПланыСчетов.Хозрасчетный.Аккредитивы,                         УчетДвиженияДенежныхСредств); // 55.01
	СтруктураФорм.Вставить(ПланыСчетов.Хозрасчетный.ЧековыеКнижки,                       УчетДвиженияДенежныхСредств); // 55.02
	СтруктураФорм.Вставить(ПланыСчетов.Хозрасчетный.ДепозитныеСчета,                     УчетДвиженияДенежныхСредств); // 55.03
	СтруктураФорм.Вставить(ПланыСчетов.Хозрасчетный.ПрочиеСпециальныеСчета,              УчетДвиженияДенежныхСредств); // 55.04
	СтруктураФорм.Вставить(ПланыСчетов.Хозрасчетный.АккредитивыВал,                      УчетДвиженияДенежныхСредств); // 55.21
	СтруктураФорм.Вставить(ПланыСчетов.Хозрасчетный.ДепозитныеСчетаВал,                  УчетДвиженияДенежныхСредств); // 55.23
	СтруктураФорм.Вставить(ПланыСчетов.Хозрасчетный.ПрочиеСпециальныеСчетаВал,           УчетДвиженияДенежныхСредств); // 55.24
	СтруктураФорм.Вставить(ПланыСчетов.Хозрасчетный.ПереводыВПути,                       УчетДвиженияДенежныхСредств); // 57.01
	СтруктураФорм.Вставить(ПланыСчетов.Хозрасчетный.ПереводыВПутиВал,                    УчетДвиженияДенежныхСредств); // 57.21
	
	Для каждого Элемент Из СтруктураФорм Цикл
		Если Счет = Элемент.Ключ ИЛИ Счет.ПринадлежитЭлементу(Элемент.Ключ) Тогда
			Возврат Новый ФорматированнаяСтрока(Элемент.Значение.ЗаголовокФормы,,,,
				"e1cib/command/ПланСчетов.Хозрасчетный.Команда." + Элемент.Значение.ИмяФормы);
		КонецЕсли;
	КонецЦикла;

КонецФункции

&НаКлиенте
Процедура ПредупреждениеОНевозможностиИзмененияСоставаВидовСубконто(Отказ)
	
	ПоказатьПредупреждение( , НСтр("ru = 'Состав видов субконто на этом счете определяется настройкой плана счетов.'"));
	Отказ = Истина;
	
КонецПроцедуры // ПредупреждениеОНевозможностиИзмененияСоставаВидовСубконто()

&НаСервереБезКонтекста
Функция ЭтоЗапрещенныйСчет(Счет)

	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("Ссылка"          , Счет);
	Запрос.УстановитьПараметр("СписокСчетов"    , ПолучитьЗапрещенныеСчета());
	Запрос.УстановитьПараметр("СписокИсключений", ПланыСчетов.Хозрасчетный.ПолучитьСчетаИсключения());
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Хозрасчетный.Ссылка КАК Ссылка
	|ИЗ
	|	ПланСчетов.Хозрасчетный КАК Хозрасчетный
	|ГДЕ
	|	Хозрасчетный.Ссылка = &Ссылка
	|	И Хозрасчетный.Ссылка В ИЕРАРХИИ(&СписокСчетов)
	|	И НЕ Хозрасчетный.Ссылка В ИЕРАРХИИ (&СписокИсключений)";
	ЗапрещенныйСчет = НЕ Запрос.Выполнить().Пустой();
	
	Возврат ЗапрещенныйСчет;

КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Объект   = Форма.Объект;
	Элементы = Форма.Элементы;
	Если НЕ Объект.Предопределенный Тогда
		Если ЗначениеЗаполнено(Объект.Родитель) Тогда
			СвойстваТекущегоРодителя = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(Объект.Родитель);
			Элементы.УчетПоПодразделениям.Доступность = СвойстваТекущегоРодителя.УчетПоПодразделениям;
			Элементы.НалоговыйУчет.Доступность        = СвойстваТекущегоРодителя.НалоговыйУчет;
		Иначе
			Если НЕ Форма.Параметры.Ключ.Пустая() Тогда
				ПараметрыСчета = ПолучитьПараметрыСчета(Объект.Ссылка);
				Элементы.УчетПоПодразделениям.Доступность = ПараметрыСчета.УчетПоПодразделениям;
				Элементы.НалоговыйУчет.Доступность        = ПараметрыСчета.НалоговыйУчет;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры // УправлениеФормой()

&НаСервере
Процедура УстановитьДоступностьРедактированияВидовСубконто(МожноРедактировать)
	
	Элементы.ВидыСубконто.Видимость                    = МожноРедактировать;
	Элементы.ВидыСубконтоЗапрещенногоСчета.Видимость   = НЕ МожноРедактировать;
	Элементы.ПредупреждениеЗапрещенногоСчета.Видимость = НЕ МожноРедактировать;
	
	Если НЕ МожноРедактировать Тогда
		Элементы.ПредупреждениеЗапрещенногоСчета.Заголовок = Новый ФорматированнаяСтрока(
			НСтр("ru='   Состав видов субконто на этом счете определяется настройкой плана счетов ""'"),
			ПолучитьСсылкуНастройкиСубконто(Объект.Ссылка),
			""".");
	КонецЕсли;
	
	Элементы.ВидыСубконтоДобавить.Доступность = МожноРедактировать;
	Элементы.ВидыСубконтоИзменить.Доступность = МожноРедактировать;
	Элементы.ВидыСубконтоУдалить.Доступность  = МожноРедактировать;
	
	Кнопка = Элементы.ВидыСубконто.КонтекстноеМеню.ПодчиненныеЭлементы.Найти("ВидыСубконтоКонтекстноеМенюДобавить");
	Если Кнопка <> Неопределено Тогда
		Кнопка.Доступность = МожноРедактировать;
	КонецЕсли;
	Кнопка = Элементы.ВидыСубконто.КонтекстноеМеню.ПодчиненныеЭлементы.Найти("ВидыСубконтоКонтекстноеМенюИзменить");
	Если Кнопка <> Неопределено Тогда
		Кнопка.Доступность = МожноРедактировать;
	КонецЕсли;
	Кнопка = Элементы.ВидыСубконто.КонтекстноеМеню.ПодчиненныеЭлементы.Найти("ВидыСубконтоКонтекстноеМенюУдалить");
	Если Кнопка <> Неопределено Тогда
		Кнопка.Доступность = МожноРедактировать;
	КонецЕсли;
	
КонецПроцедуры


#Область СлужебныеПроцедурыИФункцииБСП
// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.Печать

#КонецОбласти

#КонецОбласти
