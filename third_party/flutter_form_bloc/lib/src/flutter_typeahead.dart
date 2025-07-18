// ignore_for_file: unnecessary_this, prefer_const_constructors, prefer_const_constructors_in_immutables, prefer_generic_function_type_aliases

/*
BSD 2-Clause License

Copyright (c) 2018, AbdulRahmanAlHamali
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

 */

// # Flutter TypeAhead
/// A TypeAhead widget for Flutter, where you can show suggestions to
/// users as they type
///
/// ## Features
/// * Shows suggestions in an overlay that floats on top of other widgets
/// * Allows you to specify what the suggestions will look like through a
/// builder function
/// * Allows you to specify what happens when the user taps a suggestion
/// * Accepts all the parameters that traditional TextFields accept, like
/// decoration, custom TextEditingController, text styling, etc.
/// * Provides two versions, a normal version and a [FormField](https://docs.flutter.io/flutter/widgets/FormField-class.html)
/// version that accepts validation, submitting, etc.
/// * Provides high customizability; you can customize the suggestion box decoration,
/// the loading bar, the animation, the debounce duration, etc.
///
/// ## Installation
/// See the [installation instructions on pub](https://pub.dartlang.org/packages/flutter_typeahead#-installing-tab-).
///
/// ## Usage examples
/// You can import the package with:
/// ```dart
/// import 'package:flutter_typeahead/flutter_typeahead.dart';
/// ```
///
/// and then use it as follows:
///
/// ### Example 1:
/// ```dart
/// TypeAheadField(
///   textFieldConfiguration: TextFieldConfiguration(
///     autofocus: true,
///     style: DefaultTextStyle.of(context).style.copyWith(
///       fontStyle: FontStyle.italic
///     ),
///     decoration: InputDecoration(
///       border: OutlineInputBorder()
///     )
///   ),
///   suggestionsCallback: (pattern) async {
///     return await BackendService.getSuggestions(pattern);
///   },
///   itemBuilder: (context, suggestion) {
///     return ListTile(
///       leading: Icon(Icons.shopping_cart),
///       title: Text(suggestion['name']),
///       subtitle: Text('\$${suggestion['price']}'),
///     );
///   },
///   onSuggestionSelected: (suggestion) {
///     Navigator.of(context).push(MaterialPageRoute(
///       builder: (context) => ProductPage(product: suggestion)
///     ));
///   },
/// )
/// ```
/// In the code above, the `textFieldConfiguration` property allows us to
/// configure the displayed `TextField` as we want. In this example, we are
/// configuring the `autofocus`, `style` and `decoration` properties.
///
/// The `suggestionsCallback` is called with the search string that the user
/// types, and is expected to return a `List` of data either synchronously or
/// asynchronously. In this example, we are calling an asynchronous function
/// called `BackendService.getSuggestions` which fetches the list of
/// suggestions.
///
/// The `itemBuilder` is called to build a widget for each suggestion.
/// In this example, we build a simple `ListTile` that shows the name and the
/// price of the item. Please note that you shouldn't provide an `onTap`
/// callback here. The TypeAhead widget takes care of that.
///
/// The `onSuggestionSelected` is a callback called when the user taps a
/// suggestion. In this example, when the user taps a
/// suggestion, we navigate to a page that shows us the information of the
/// tapped product.
///
/// ### Example 2:
/// Here's another example, where we use the TypeAheadFormField inside a `Form`:
/// ```dart
/// final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
/// final TextEditingController _typeAheadController = TextEditingController();
/// String _selectedCity;
/// ...
/// Form(
///   key: this._formKey,
///   child: Padding(
///     padding: EdgeInsets.all(32.0),
///     child: Column(
///       children: <Widget>[
///         Text(
///           'What is your favorite city?'
///         ),
///         TypeAheadFormField(
///           textFieldConfiguration: TextFieldConfiguration(
///             controller: this._typeAheadController,
///             decoration: InputDecoration(
///               labelText: 'City'
///             )
///           ),
///           suggestionsCallback: (pattern) {
///             return CitiesService.getSuggestions(pattern);
///           },
///           itemBuilder: (context, suggestion) {
///             return ListTile(
///               title: Text(suggestion),
///             );
///           },
///           transitionBuilder: (context, suggestionsBox, controller) {
///             return suggestionsBox;
///           },
///           onSuggestionSelected: (suggestion) {
///             this._typeAheadController.text = suggestion;
///           },
///           validator: (value) {
///             if (value.isEmpty) {
///               return 'Please select a city';
///             }
///           },
///           onSaved: (value) => this._selectedCity = value,
///         ),
///         SizedBox(height: 10.0,),
///         ElevatedButton(
///           child: Text('Submit'),
///           onPressed: () {
///             if (this._formKey.state.validate()) {
///               this._formKey.state.save();
///               ScaffoldMessenger.of(context).showSnackBar(SnackBar(
///                 content: Text('Your Favorite City is ${this._selectedCity}')
///               ));
///             }
///           },
///         )
///       ],
///     ),
///   ),
/// )
/// ```
/// Here, we assign to the `controller` property of the `textFieldConfiguration`
/// a `TextEditingController` that we call `_typeAheadController`.
/// We use this controller in the `onSuggestionSelected` callback to set the
/// value of the `TextField` to the selected suggestion.
///
/// The `validator` callback can be used like any `FormField.validator`
/// function. In our example, it checks whether a value has been entered,
/// and displays an error message if not. The `onSaved` callback is used to
/// save the value of the field to the `_selectedCity` member variable.
///
/// The `transitionBuilder` allows us to customize the animation of the
/// suggestion box. In this example, we are returning the suggestionsBox
/// immediately, meaning that we don't want any animation.
///
/// ## Customizations
/// TypeAhead widgets consist of a TextField and a suggestion box that shows
/// as the user types. Both are highly customizable
///
/// ### Customizing the TextField
/// You can customize the text field using the `textFieldConfiguration` property.
/// You provide this property with an instance of `TextFieldConfiguration`,
/// which allows you to configure all the usual properties of `TextField`, like
/// `decoration`, `style`, `controller`, `focusNode`, `autofocus`, `enabled`,
/// etc.
///
/// ### Customizing the Suggestions Box
/// TypeAhead provides default configurations for the suggestions box. You can,
/// however, override most of them.
///
/// #### Customizing the loader, the error and the "no items found" message
/// You can use the [loadingSuggestionsBuilder], [suggestionsErrorBuilder] and [suggestionsNotFoundBuilder] to
/// customize their corresponding widgets. For example, to show a custom error
/// widget:
/// ```dart
/// errorBuilder: (BuildContext context, Object error) =>
///   Text(
///     '$error',
///     style: TextStyle(
///       color: Theme.of(context).errorColor
///     )
///   )
/// ```
/// #### Customizing the animation
/// You can customize the suggestion box animation through 3 parameters: the
/// `animationDuration`, the `animationStart`, and the `transitionBuilder`.
///
/// The `animationDuration` specifies how long the animation should take, while the
/// `animationStart` specified what point (between 0.0 and 1.0) the animation
/// should start from. The `transitionBuilder` accepts the `suggestionsBox` and
/// `animationController` as parameters, and should return a widget that uses
/// the `animationController` to animate the display of the `suggestionsBox`.
/// For example:
/// ```dart
/// transitionBuilder: (context, suggestionsBox, animationController) =>
///   FadeTransition(
///     child: suggestionsBox,
///     opacity: CurvedAnimation(
///       parent: animationController,
///       curve: Curves.fastOutSlowIn
///     ),
///   )
/// ```
/// This uses [FadeTransition](https://docs.flutter.io/flutter/widgets/FadeTransition-class.html)
/// to fade the `suggestionsBox` into the view. Note how the
/// `animationController` was provided as the parent of the animation.
///
/// In order to fully remove the animation, `transitionBuilder` should simply
/// return the `suggestionsBox`. This callback could also be used to wrap the
/// `suggestionsBox` with any desired widgets, not necessarily for animation.
///
/// #### Customizing the debounce duration
/// The suggestions box does not fire for each character the user types. Instead,
/// we wait until the user is idle for a duration of time, and then call the
/// `suggestionsCallback`. The duration defaults to 300 milliseconds, but can be
/// configured using the `debounceDuration` parameter.
///
/// #### Customizing the offset of the suggestions box
/// By default, the suggestions box is displayed 5 pixels below the `TextField`.
/// You can change this by changing the `suggestionsBoxVerticalOffset` property.
///
/// #### Customizing the decoration of the suggestions box
/// You can also customize the decoration of the suggestions box using the
/// `suggestionsBoxDecoration` property. For example, to remove the elevation
/// of the suggestions box, you can write:
/// ```dart
/// suggestionsBoxDecoration: SuggestionsBoxDecoration(
///   elevation: 0.0
/// )
/// ```
library;

import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:rxdart/rxdart.dart';

typedef FutureOr<List<T>> SuggestionsCallback<T>(String pattern);
typedef Widget ItemBuilder<T>(BuildContext context, T itemData);
typedef void SuggestionSelectionCallback<T>(T suggestion);
typedef void SuggestionRemovedCallback<T>(T suggestion);
typedef Widget ErrorBuilder(BuildContext context, Object? error);

typedef AnimationTransitionBuilder(
    BuildContext context, Widget child, AnimationController? controller);

/// A [TextField](https://docs.flutter.io/flutter/material/TextField-class.html)
/// that displays a list of suggestions as the user types
///
/// See also:
///
/// * [TypeAheadFormField], a [FormField](https://docs.flutter.io/flutter/widgets/FormField-class.html)
/// implementation of [TypeAheadField] that allows the value to be saved,
/// validated, etc.
class TypeAheadField<T> extends StatefulWidget {
  /// Called with the search pattern to get the search suggestions.
  ///
  /// This callback must not be null. It is be called by the TypeAhead widget
  /// and provided with the search pattern. It should return a [List](https://api.dartlang.org/stable/2.0.0/dart-core/List-class.html)
  /// of suggestions either synchronously, or asynchronously (as the result of a
  /// [Future](https://api.dartlang.org/stable/dart-async/Future-class.html)).
  /// Typically, the list of suggestions should not contain more than 4 or 5
  /// entries. These entries will then be provided to [itemBuilder] to display
  /// the suggestions.
  ///
  /// Example:
  /// ```dart
  /// suggestionsCallback: (pattern) async {
  ///   return await _getSuggestions(pattern);
  /// }
  /// ```
  final SuggestionsCallback<T>? suggestionsCallback;

  /// Called when a suggestion is tapped.
  ///
  /// This callback must not be null. It is called by the TypeAhead widget and
  /// provided with the value of the tapped suggestion.
  ///
  /// For example, you might want to navigate to a specific view when the user
  /// tabs a suggestion:
  /// ```dart
  /// onSuggestionSelected: (suggestion) {
  ///   Navigator.of(context).push(MaterialPageRoute(
  ///     builder: (context) => SearchResult(
  ///       searchItem: suggestion
  ///     )
  ///   ));
  /// }
  /// ```
  ///
  /// Or to set the value of the text field:
  /// ```dart
  /// onSuggestionSelected: (suggestion) {
  ///   _controller.text = suggestion['name'];
  /// }
  /// ```
  final SuggestionSelectionCallback<T> onSuggestionSelected;

  final SuggestionRemovedCallback<T> onSuggestionRemoved;

  final bool showSuggestionsWhenIsEmpty;

  final bool removeSuggestionOnLongPress;

  /// Called for each suggestion returned by [suggestionsCallback] to build the
  /// corresponding widget.
  ///
  /// This callback must not be null. It is called by the TypeAhead widget for
  /// each suggestion, and expected to build a widget to display this
  /// suggestion's info. For example:
  ///
  /// ```dart
  /// itemBuilder: (context, suggestion) {
  ///   return ListTile(
  ///     title: Text(suggestion['name']),
  ///     subtitle: Text('USD' + suggestion['price'].toString())
  ///   );
  /// }
  /// ```
  final ItemBuilder<T> itemBuilder;

  /// The decoration of the material sheet that contains the suggestions.
  ///
  /// If null, default decoration with an elevation of 4.0 is used
  final SuggestionsBoxDecoration suggestionsBoxDecoration;

  /// Used to control the `_SuggestionsBox`. Allows manual control to
  /// open, close, toggle, or resize the `_SuggestionsBox`.
  final SuggestionsBoxController? suggestionsBoxController;

  /// The duration to wait after the user stops typing before calling
  /// [suggestionsCallback]
  ///
  /// This is useful, because, if not set, a request for suggestions will be
  /// sent for every character that the user types.
  ///
  /// This duration is set by default to 300 milliseconds
  final Duration debounceDuration;

  /// Called when waiting for [suggestionsCallback] to return.
  ///
  /// It is expected to return a widget to display while waiting.
  /// For example:
  /// ```dart
  /// (BuildContext context) {
  ///   return Text('Loading...');
  /// }
  /// ```
  ///
  /// If not specified, a [CircularProgressIndicator](https://docs.flutter.io/flutter/material/CircularProgressIndicator-class.html) is shown
  final WidgetBuilder? loadingBuilder;

  /// Called when [suggestionsCallback] returns an empty array.
  ///
  /// It is expected to return a widget to display when no suggestions are
  /// available.
  /// For example:
  /// ```dart
  /// (BuildContext context) {
  ///   return Text('No Items Found!');
  /// }
  /// ```
  ///
  /// If not specified, a simple text is shown
  final WidgetBuilder? noItemsFoundBuilder;

  /// Called when [suggestionsCallback] throws an exception.
  ///
  /// It is called with the error object, and expected to return a widget to
  /// display when an exception is thrown
  /// For example:
  /// ```dart
  /// (BuildContext context, error) {
  ///   return Text('$error');
  /// }
  /// ```
  ///
  /// If not specified, the error is shown in [ThemeData.errorColor](https://docs.flutter.io/flutter/material/ThemeData/errorColor.html)
  final ErrorBuilder? errorBuilder;

  /// Called to display animations when [suggestionsCallback] returns suggestions
  ///
  /// It is provided with the suggestions box instance and the animation
  /// controller, and expected to return some animation that uses the controller
  /// to display the suggestion box.
  ///
  /// For example:
  /// ```dart
  /// transitionBuilder: (context, suggestionsBox, animationController) {
  ///   return FadeTransition(
  ///     child: suggestionsBox,
  ///     opacity: CurvedAnimation(
  ///       parent: animationController,
  ///       curve: Curves.fastOutSlowIn
  ///     ),
  ///   );
  /// }
  /// ```
  /// This argument is best used with [animationDuration] and [animationStart]
  /// to fully control the animation.
  ///
  /// To fully remove the animation, just return `suggestionsBox`
  ///
  /// If not specified, a [SizeTransition](https://docs.flutter.io/flutter/widgets/SizeTransition-class.html) is shown.
  final AnimationTransitionBuilder? transitionBuilder;

  /// The duration that [transitionBuilder] animation takes.
  ///
  /// This argument is best used with [transitionBuilder] and [animationStart]
  /// to fully control the animation.
  ///
  /// Defaults to 500 milliseconds.
  final Duration animationDuration;

  /// Called when the user taps on this text field.
  ///
  /// The text field builds a [GestureDetector] to handle input events like tap,
  /// to trigger focus requests, to move the caret, adjust the selection, etc.
  /// Handling some of those events by wrapping the text field with a competing
  /// GestureDetector is problematic.
  ///
  /// To unconditionally handle taps, without interfering with the text field's
  /// internal gesture detector, provide this callback.
  ///
  /// If the text field is created with [enabled] false, taps will not be
  /// recognized.
  ///
  /// To be notified when the text field gains or loses the focus, provide a
  /// [focusNode] and add a listener to that.
  ///
  /// To listen to arbitrary pointer events without competing with the
  /// text field's internal gesture detector, use a [Listener].
  final GestureTapCallback? onTap;

  /// Determine the [SuggestionBox]'s direction.
  ///
  /// If [AxisDirection.down], the [SuggestionBox] will be below the [TextField]
  /// and the [_SuggestionsList] will grow **down**.
  ///
  /// If [AxisDirection.up], the [SuggestionBox] will be above the [TextField]
  /// and the [_SuggestionsList] will grow **up**.
  ///
  /// [AxisDirection.left] and [AxisDirection.right] are not allowed.
  final AxisDirection direction;

  /// The value at which the [transitionBuilder] animation starts.
  ///
  /// This argument is best used with [transitionBuilder] and [animationDuration]
  /// to fully control the animation.
  ///
  /// Defaults to 0.25.
  final double animationStart;

  /// The configuration of the [TextField](https://docs.flutter.io/flutter/material/TextField-class.html)
  /// that the TypeAhead widget displays
  final TextFieldConfiguration<T> textFieldConfiguration;

  /// How far below the text field should the suggestions box be
  ///
  /// Defaults to 5.0
  final double suggestionsBoxVerticalOffset;

  /// If set to true, suggestions will be fetched immediately when the field is
  /// added to the view.
  ///
  /// But the suggestions box will only be shown when the field receives focus.
  /// To make the field receive focus immediately, you can set the `autofocus`
  /// property in the [textFieldConfiguration] to true
  ///
  /// Defaults to false
  final bool getImmediateSuggestions;

  /// If set to true, no loading box will be shown while suggestions are
  /// being fetched. [loadingBuilder] will also be ignored.
  ///
  /// Defaults to false.
  final bool hideOnLoading;

  /// If set to true, nothing will be shown if there are no results.
  /// [noItemsFoundBuilder] will also be ignored.
  ///
  /// Defaults to false.
  final bool hideOnEmpty;

  /// If set to true, nothing will be shown if there is an error.
  /// [errorBuilder] will also be ignored.
  ///
  /// Defaults to false.
  final bool hideOnError;

  /// If set to false, the suggestions box will stay opened after
  /// the keyboard is closed.
  ///
  /// Defaults to true.
  final bool hideSuggestionsOnKeyboardHide;

  /// If set to false, the suggestions box will show a circular
  /// progress indicator when retrieving suggestions.
  ///
  /// Defaults to true.
  final bool keepSuggestionsOnLoading;

  /// If set to true, the suggestions box will remain opened even after
  /// selecting a suggestion.
  ///
  /// Note that if this is enabled, the only way
  /// to close the suggestions box is either manually via the
  /// `SuggestionsBoxController` or when the user closes the software
  /// keyboard if `hideSuggestionsOnKeyboardHide` is set to true. Users
  /// with a physical keyboard will be unable to close the
  /// box without a manual way via `SuggestionsBoxController`.
  ///
  /// Defaults to false.
  final bool keepSuggestionsOnSuggestionSelected;

  /// If set to true, in the case where the suggestions box has less than
  /// _SuggestionsBoxController.minOverlaySpace to grow in the desired [direction], the direction axis
  /// will be temporarily flipped if there's more room available in the opposite
  /// direction.
  ///
  /// Defaults to false
  final bool autoFlipDirection;

  /// Creates a [TypeAheadField]
  TypeAheadField({
    super.key,
    required this.suggestionsCallback,
    required this.itemBuilder,
    required this.onSuggestionSelected,
    required this.onSuggestionRemoved,
    this.textFieldConfiguration = const TextFieldConfiguration(),
    this.suggestionsBoxDecoration = const SuggestionsBoxDecoration(),
    this.debounceDuration = const Duration(milliseconds: 300),
    this.suggestionsBoxController,
    this.loadingBuilder,
    this.noItemsFoundBuilder,
    this.errorBuilder,
    this.transitionBuilder,
    this.animationStart = 0.25,
    this.animationDuration = const Duration(milliseconds: 500),
    this.getImmediateSuggestions = false,
    this.suggestionsBoxVerticalOffset = 5.0,
    this.direction = AxisDirection.down,
    this.hideOnLoading = false,
    this.hideOnEmpty = false,
    this.hideOnError = false,
    this.hideSuggestionsOnKeyboardHide = true,
    this.keepSuggestionsOnLoading = true,
    this.keepSuggestionsOnSuggestionSelected = false,
    this.autoFlipDirection = false,
    required this.removeSuggestionOnLongPress,
    this.showSuggestionsWhenIsEmpty = false,
    this.onTap,
  })  : assert(animationStart >= 0.0 && animationStart <= 1.0),
        assert(
            direction == AxisDirection.down || direction == AxisDirection.up);

  @override
  State<TypeAheadField<T>> createState() => _TypeAheadFieldState<T>();
}

class _TypeAheadFieldState<T> extends State<TypeAheadField<T>>
    with WidgetsBindingObserver {
  FocusNode? _focusNode;
  TextEditingController? _textEditingController;
  _SuggestionsBox? _suggestionsBox;

  TextEditingController? get _effectiveController =>
      widget.textFieldConfiguration.controller ?? _textEditingController;
  FocusNode? get _effectiveFocusNode =>
      widget.textFieldConfiguration.focusNode ?? _focusNode;
  late VoidCallback _focusNodeListener;

  final LayerLink _layerLink = LayerLink();

  // Timer that resizes the suggestion box on each tick. Only active when the user is scrolling.
  Timer? _resizeOnScrollTimer;
  // The rate at which the suggestion box will resize when the user is scrolling
  final Duration _resizeOnScrollRefreshRate = const Duration(milliseconds: 500);

  late StreamSubscription<bool> _keyboardSubscription;

  late PublishSubject _hideSuggestionsController;

  @override
  void didChangeMetrics() {
    // Catch keyboard event and orientation change; resize suggestions list
    this._suggestionsBox!.onChangeMetrics();
  }

  @override
  void dispose() {
    // TODO: check this
    // if (this._suggestionsBox._isOpened) {
    //   this._suggestionsBox._overlayEntry?.remove();
    // }
    this._suggestionsBox!.widgetMounted = false;
    WidgetsBinding.instance.removeObserver(this);

    if (isWebMobile) {
      _keyboardSubscription.cancel();
    }

    _effectiveFocusNode!.removeListener(_focusNodeListener);
    _focusNode?.dispose();
    _resizeOnScrollTimer?.cancel();

    //TODO: create A Pull Request, dispose the controller create here
    _textEditingController?.dispose();
    //TODO: Create Pull Request, when dispose the widget and the suggestions in showed need to close
    _suggestionsBox!.close();

    _hideSuggestionsController.close();
    super.dispose();
  }

  late final KeyboardVisibilityController keyboardVisibilityController;
  late final bool isWebMobile;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _hideSuggestionsController = PublishSubject<void>();

    if (widget.textFieldConfiguration.controller == null) {
      this._textEditingController = TextEditingController();
    }

    if (widget.textFieldConfiguration.focusNode == null) {
      this._focusNode = FocusNode();
    }
    isWebMobile = kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.iOS ||
            defaultTargetPlatform == TargetPlatform.android);
    this._suggestionsBox =
        _SuggestionsBox(context, widget.direction, widget.autoFlipDirection);
    widget.suggestionsBoxController?._suggestionsBox = this._suggestionsBox;
    if (isWebMobile) {
      keyboardVisibilityController = KeyboardVisibilityController();
      _keyboardSubscription =
          keyboardVisibilityController.onChange.listen((bool visible) {
        setState(() {
          if (widget.hideSuggestionsOnKeyboardHide && !visible) {
            _effectiveFocusNode!.unfocus();
          }
        });
      });
    }

    this._focusNodeListener = () {
      if (_effectiveFocusNode!.hasFocus) {
        this._suggestionsBox?.open();
      } else {
        _hideSuggestions();
      }
    };

    WidgetsBinding.instance.addPostFrameCallback((duration) {
      if (mounted) {
        this._initOverlayEntry();
        // calculate initial suggestions list size
        this._suggestionsBox!.resize();

        this._effectiveFocusNode!.addListener(_focusNodeListener);

        // in case we already missed the focus event
        if (this._effectiveFocusNode!.hasFocus) {
          this._suggestionsBox?.open();
        }

        ScrollableState? scrollableState = Scrollable.maybeOf(context);
        if (scrollableState != null) {
          scrollableState.position.isScrollingNotifier.addListener(() {
            bool isScrolling =
                scrollableState.position.isScrollingNotifier.value;
            _resizeOnScrollTimer?.cancel();
            if (isScrolling) {
              // Scroll started
              _resizeOnScrollTimer =
                  Timer.periodic(_resizeOnScrollRefreshRate, (timer) {
                _suggestionsBox!.resize();
              });
            } else {
              // Scroll finished
              _suggestionsBox!.resize();
            }
          });
        }
      }
    });
  }

  /// TODO: Create Pull Request
  /// Called for resize the suggestions box when have error
  void _onChange() {
    WidgetsBinding.instance.addPostFrameCallback((duration) {
      _suggestionsBox!.resize();
    });
  }

  void _hideSuggestions() {
    _hideSuggestionsController.add(null);
    // TODO: check: removed this for animate hide suggestions
    // this._suggestionsBox.close();
  }

  void _initOverlayEntry() {
    this._suggestionsBox!._overlayEntry = OverlayEntry(builder: (context) {
      final suggestionsList = _SuggestionsList<T>(
        suggestionsBox: _suggestionsBox,
        showSuggestionsWhenIsEmpty: widget.showSuggestionsWhenIsEmpty,
        hideSuggestions: _hideSuggestionsController.stream,
        removeSuggestionOnLongPress: widget.removeSuggestionOnLongPress,
        decoration: widget.suggestionsBoxDecoration,
        debounceDuration: widget.debounceDuration,
        controller: this._effectiveController,
        loadingBuilder: widget.loadingBuilder,
        noItemsFoundBuilder: widget.noItemsFoundBuilder,
        errorBuilder: widget.errorBuilder,
        transitionBuilder: widget.transitionBuilder,
        suggestionsCallback: widget.suggestionsCallback,
        animationDuration: widget.animationDuration,
        animationStart: widget.animationStart,
        getImmediateSuggestions: widget.getImmediateSuggestions,
        onSuggestionSelected: (T selection) {
          if (!widget.keepSuggestionsOnSuggestionSelected) {
            this._effectiveFocusNode!.unfocus();
            _hideSuggestions();
          }
          widget.onSuggestionSelected(selection);
        },
        onSuggestionRemoved: widget.onSuggestionRemoved,
        itemBuilder: widget.itemBuilder,
        direction: _suggestionsBox!.direction,
        hideOnLoading: widget.hideOnLoading,
        hideOnEmpty: widget.hideOnEmpty,
        hideOnError: widget.hideOnError,
        keepSuggestionsOnLoading: widget.keepSuggestionsOnLoading,
      );

      double w = _suggestionsBox!.textBoxWidth;
      if (widget.suggestionsBoxDecoration.constraints != null) {
        if (widget.suggestionsBoxDecoration.constraints!.minWidth != 0.0 &&
            widget.suggestionsBoxDecoration.constraints!.maxWidth !=
                double.infinity) {
          w = (widget.suggestionsBoxDecoration.constraints!.minWidth +
                  widget.suggestionsBoxDecoration.constraints!.maxWidth) /
              2;
        } else if (widget.suggestionsBoxDecoration.constraints!.minWidth !=
                0.0 &&
            widget.suggestionsBoxDecoration.constraints!.minWidth > w) {
          w = widget.suggestionsBoxDecoration.constraints!.minWidth;
        } else if (widget.suggestionsBoxDecoration.constraints!.maxWidth !=
                double.infinity &&
            widget.suggestionsBoxDecoration.constraints!.maxWidth < w) {
          w = widget.suggestionsBoxDecoration.constraints!.maxWidth;
        }
      }

      return Positioned(
        width: w,
        child: CompositedTransformFollower(
          link: this._layerLink,
          showWhenUnlinked: false,
          offset: Offset(
              0.0,
              _suggestionsBox!.direction == AxisDirection.down
                  ? _suggestionsBox!.textBoxHeight +
                      widget.suggestionsBoxVerticalOffset
                  : _suggestionsBox!.directionUpOffset),
          child: _suggestionsBox!.direction == AxisDirection.down
              ? suggestionsList
              : FractionalTranslation(
                  translation:
                      Offset(0.0, -1.0), // visually flips list to go up
                  child: suggestionsList,
                ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: this._layerLink,
      child: TextField(
        focusNode: this._effectiveFocusNode,
        controller: this._effectiveController,
        autofillHints: widget.textFieldConfiguration.autofillHints,
        decoration: widget.textFieldConfiguration.decoration,
        style: widget.textFieldConfiguration.style,
        textAlign: widget.textFieldConfiguration.textAlign,
        enabled: widget.textFieldConfiguration.enabled,
        keyboardType: widget.textFieldConfiguration.keyboardType,
        autofocus: widget.textFieldConfiguration.autofocus,
        inputFormatters: widget.textFieldConfiguration.inputFormatters,
        autocorrect: widget.textFieldConfiguration.autocorrect,
        minLines: widget.textFieldConfiguration.minLines,
        maxLines: widget.textFieldConfiguration.maxLines,
        maxLength: widget.textFieldConfiguration.maxLength,
        maxLengthEnforcement:
            widget.textFieldConfiguration.maxLengthEnforcement,
        obscureText: widget.textFieldConfiguration.obscureText!,
        onTap: widget.onTap,
        onChanged: (value) {
          if (widget.textFieldConfiguration.onChanged != null) {
            widget.textFieldConfiguration.onChanged!(value);
          }
          _onChange();
        },
        onSubmitted: widget.textFieldConfiguration.onSubmitted,
        onEditingComplete: widget.textFieldConfiguration.onEditingComplete,
        scrollPadding: widget.textFieldConfiguration.scrollPadding,
        textInputAction: widget.textFieldConfiguration.textInputAction,
        textCapitalization: widget.textFieldConfiguration.textCapitalization,
        keyboardAppearance: widget.textFieldConfiguration.keyboardAppearance,
        cursorWidth: widget.textFieldConfiguration.cursorWidth,
        cursorRadius: widget.textFieldConfiguration.cursorRadius,
        cursorColor: widget.textFieldConfiguration.cursorColor,
        textDirection: widget.textFieldConfiguration.textDirection,
        buildCounter: widget.textFieldConfiguration.buildCounter,
        dragStartBehavior: widget.textFieldConfiguration.dragStartBehavior!,
        enableInteractiveSelection:
            widget.textFieldConfiguration.enableInteractiveSelection!,
        enableSuggestions: widget.textFieldConfiguration.enableSuggestions!,
        expands: widget.textFieldConfiguration.expands!,
        readOnly: widget.textFieldConfiguration.readOnly!,
        scrollController: widget.textFieldConfiguration.scrollController,
        scrollPhysics: widget.textFieldConfiguration.scrollPhysics,
        showCursor: widget.textFieldConfiguration.showCursor,
        strutStyle: widget.textFieldConfiguration.strutStyle,
        textAlignVertical: widget.textFieldConfiguration.textAlignVertical,
        // ignore: deprecated_member_use, deprecated_member_use_from_same_package
        toolbarOptions: widget.textFieldConfiguration.toolbarOptions,
      ),
    );
  }
}

class _SuggestionsList<T> extends StatefulWidget {
  final _SuggestionsBox? suggestionsBox;
  final TextEditingController? controller;
  final bool getImmediateSuggestions;
  final SuggestionSelectionCallback<T>? onSuggestionSelected;
  final bool removeSuggestionOnLongPress;
  final SuggestionRemovedCallback<T>? onSuggestionRemoved;
  final SuggestionsCallback<T>? suggestionsCallback;
  final ItemBuilder<T>? itemBuilder;
  final SuggestionsBoxDecoration? decoration;
  final Duration? debounceDuration;
  final WidgetBuilder? loadingBuilder;
  final WidgetBuilder? noItemsFoundBuilder;
  final ErrorBuilder? errorBuilder;
  final AnimationTransitionBuilder? transitionBuilder;
  final Duration? animationDuration;
  final double? animationStart;
  final AxisDirection? direction;
  final bool? hideOnLoading;
  final bool? hideOnEmpty;
  final bool? hideOnError;
  final bool? keepSuggestionsOnLoading;
  final bool? showSuggestionsWhenIsEmpty;
  final Stream<void> hideSuggestions;

  _SuggestionsList({
    required this.suggestionsBox,
    required this.hideSuggestions,
    this.controller,
    this.getImmediateSuggestions = false,
    this.onSuggestionSelected,
    this.onSuggestionRemoved,
    this.suggestionsCallback,
    this.itemBuilder,
    this.decoration,
    this.debounceDuration,
    this.loadingBuilder,
    this.noItemsFoundBuilder,
    this.errorBuilder,
    this.transitionBuilder,
    this.animationDuration,
    this.animationStart,
    this.direction,
    this.hideOnLoading,
    this.hideOnEmpty,
    this.hideOnError,
    this.keepSuggestionsOnLoading,
    this.showSuggestionsWhenIsEmpty,
    required this.removeSuggestionOnLongPress,
  });

  @override
  _SuggestionsListState<T> createState() => _SuggestionsListState<T>();
}

class _SuggestionsListState<T> extends State<_SuggestionsList<T>>
    with SingleTickerProviderStateMixin {
  List<T>? _suggestions;
  late VoidCallback _controllerListener;
  Timer? _debounceTimer;
  bool? _isLoading, _isQueued;
  Object? _error;
  AnimationController? _animationController;
  String? _lastTextValue;
  Object? _activeCallbackIdentity;
  StreamSubscription<void>? _hideSuggestionsSubscription;

  @override
  void initState() {
    super.initState();

    this._animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    this._isLoading = false;
    this._isQueued = false;
    this._lastTextValue = widget.controller!.text;

    if (widget.getImmediateSuggestions) {
      this._getSuggestions();
    }

    this._controllerListener = () {
      // If we came here because of a change in selected text, not because of
      // actual change in text
      if (widget.controller!.text == this._lastTextValue) return;

      this._lastTextValue = widget.controller!.text;

      this._debounceTimer?.cancel();
      this._debounceTimer = Timer(widget.debounceDuration!, () async {
        if (this._debounceTimer!.isActive) return;
        if (_isLoading!) {
          _isQueued = true;
          return;
        }

        await this._getSuggestions();
        while (_isQueued!) {
          _isQueued = false;
          await this._getSuggestions();
        }
      });
    };

    widget.controller!.addListener(this._controllerListener);

    _hideSuggestionsSubscription = widget.hideSuggestions.listen((_) {
      WidgetsBinding.instance.addPostFrameCallback((duration) {
        if (this.mounted) {
          setState(() {
            this
                ._animationController!
                .reverse(from: widget.animationStart)
                .then<void>((_) {
              widget.suggestionsBox!.close();
            });
          });
        }
      });
    });
  }

  Future<void> _getSuggestions() async {
    if (mounted) {
      if (widget.suggestionsCallback == null) return;
      if (!widget.showSuggestionsWhenIsEmpty! &&
          widget.controller!.text.trim().isEmpty) {
        setState(() {
          this._animationController!.reverse(from: widget.animationStart);
          this._suggestions = null;
        });
      } else {
        setState(() {
          this._animationController!.forward(
              from:
                  widget.keepSuggestionsOnLoading! || _isLoading! ? 1.0 : 0.0);

          this._isLoading = true;
          this._error = null;
        });

        List<T> suggestions = [];
        Object? error;

        final Object callbackIdentity = Object();
        this._activeCallbackIdentity = callbackIdentity;

        try {
          final suggestionsStopwatch = Stopwatch()..start();
          suggestions =
              await widget.suggestionsCallback!(widget.controller!.text);
          suggestionsStopwatch.stop();

          final remainingElapsedTime =
              widget.animationDuration!.inMilliseconds -
                  suggestionsStopwatch.elapsedMilliseconds;

          if (remainingElapsedTime > 0 && !widget.hideOnLoading!) {
            // use this for show the animation for open and close
            await Future.delayed(Duration(milliseconds: remainingElapsedTime));
          }
        } catch (e) {
          error = e;
        }

        // If another callback has been issued, omit this one
        if (this._activeCallbackIdentity != callbackIdentity) return;

        if (this.mounted) {
          // if it wasn't removed in the meantime
          //TODO: create Pull Request not animate when the suggestions are the previous suggestions

          void updateSuggestions(Object? error, List<T> suggestions) {
            this._error = error;
            this._isLoading = false;
            this._suggestions = suggestions;
          }

          if (error != null ||
              suggestions.isEmpty ||
              ListEquality<dynamic>().equals(_suggestions, suggestions)) {
            setState(() {
              this._animationController!.forward(from: 1.0);
              updateSuggestions(error, suggestions);
            });
          } else if (_suggestions == null) {
            setState(() {
              this
                  ._animationController!
                  .reverse(from: widget.animationStart)
                  .then<dynamic>((_) {
                if (this.mounted) {
                  setState(() {
                    this._animationController!.forward(from: 0.0);
                    updateSuggestions(error, suggestions);
                  });
                }
              });
            });
          } else {
            setState(() {
              this
                  ._animationController!
                  .reverse(from: widget.animationStart)
                  .then<dynamic>((_) {
                if (this.mounted) {
                  setState(() {
                    this._animationController!.forward(from: 0.0);
                    updateSuggestions(error, suggestions);
                  });
                }
              });
            });
          }
        }
      }
    }
  }

  @override
  void dispose() {
    _animationController!.dispose();

    _hideSuggestionsSubscription?.cancel();

    ///TODO: Create Pull Request
    /// fix  `A TextEditingController was used after being disposed.`
    /// You don't need to remove here,
    /// because it will removed where call[TextEditingController.dispose]
    // widget.controller.removeListener(this._controllerListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (this._suggestions == null && this._isLoading == false) {
      return Container();
    }

    Widget child;
    if (this._isLoading!) {
      if (widget.hideOnLoading! && !widget.keepSuggestionsOnLoading!) {
        child = Container(height: 0);
      } else {
        child = createLoadingWidget();
      }
    } else if (this._error != null) {
      if (widget.hideOnError!) {
        child = Container(height: 0);
      } else {
        child = createErrorWidget();
      }
    } else if (this._suggestions!.isEmpty) {
      if (widget.hideOnEmpty!) {
        child = Container(height: 0);
      } else {
        child = createNoItemsFoundWidget();
      }
    } else {
      child = createSuggestionsWidget();
    }

    var animationChild = widget.transitionBuilder != null
        ? widget.transitionBuilder!(context, child, this._animationController)
        : SizeTransition(
            axisAlignment: -1.0,
            sizeFactor: CurvedAnimation(
              parent: this._animationController!,
              curve: Curves.fastOutSlowIn,
            ),
            child: child,
          );

    BoxConstraints constraints;
    if (widget.decoration!.constraints == null) {
      constraints = BoxConstraints(
        maxHeight: widget.suggestionsBox!.maxHeight,
      );
    } else {
      double maxHeight = min(widget.decoration!.constraints!.maxHeight,
          widget.suggestionsBox!.maxHeight);
      constraints = widget.decoration!.constraints!.copyWith(
        minHeight: min(widget.decoration!.constraints!.minHeight, maxHeight),
        maxHeight: maxHeight,
      );
    }

    var container = Material(
      elevation: widget.decoration!.elevation,
      color: widget.decoration!.color,
      shape: widget.decoration!.shape,
      borderRadius: widget.decoration!.borderRadius,
      shadowColor: widget.decoration!.shadowColor,
      child: ConstrainedBox(
        constraints: constraints,
        child: animationChild,
      ),
    );

    return container;
  }

  Widget createLoadingWidget() {
    Widget child;
    if (widget.keepSuggestionsOnLoading! &&
        this._suggestions != null &&
        this._suggestions!.isNotEmpty) {
      child = createSuggestionsWidget();
    } else {
      child = widget.loadingBuilder != null
          ? widget.loadingBuilder!(context)
          : Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: CircularProgressIndicator(),
              ),
            );
    }

    return child;
  }

  Widget createErrorWidget() {
    return widget.errorBuilder != null
        ? widget.errorBuilder!(context, this._error)
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Error: ${this._error}',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          );
  }

  Widget createNoItemsFoundWidget() {
    return widget.noItemsFoundBuilder != null
        ? widget.noItemsFoundBuilder!(context)
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'No Items Found!',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Theme.of(context).disabledColor, fontSize: 18.0),
            ),
          );
  }

  Widget createSuggestionsWidget() {
    final suggestions = List<T>.from(_suggestions!);

    Widget buildItem(
        BuildContext context, int index, Animation<double> animation) {
      final suggestion = suggestions[index];

      BorderRadius? borderRadius;
      if (widget.decoration!.borderRadius == null) {
        if (suggestions.length == 1) {
          borderRadius = widget.decoration!.borderRadius;
        } else if (index == 0) {
          borderRadius = BorderRadius.only(
            topLeft: widget.decoration!.borderRadius!.topLeft,
            topRight: widget.decoration!.borderRadius!.topRight,
          );
        } else if (index == suggestions.length - 1) {
          borderRadius = BorderRadius.only(
            bottomLeft: widget.decoration!.borderRadius!.bottomLeft,
            bottomRight: widget.decoration!.borderRadius!.bottomRight,
          );
        }
      }

      return InkWell(
        borderRadius: borderRadius,
        onLongPress: widget.onSuggestionRemoved == null ||
                !widget.removeSuggestionOnLongPress
            ? null
            : () {
                AnimatedList.of(context).removeItem(index,
                    (context, animation) {
                  return SizeTransition(
                    axis: Axis.vertical,
                    sizeFactor: animation,
                    child: widget.itemBuilder!(context, suggestion),
                  );
                });
                _suggestions = suggestions..removeAt(index);

                widget.onSuggestionRemoved!(suggestion);
              },
        onTap: () {
          widget.onSuggestionSelected!(suggestion);
        },
        child: widget.itemBuilder!(context, suggestion),
      );
    }

    Widget child = AnimatedList(
      key: Key('__suggestionsList${suggestions.length}__'),
      padding: EdgeInsets.zero,
      primary: false,
      shrinkWrap: true,

      initialItemCount: suggestions.length,

      reverse: widget.suggestionsBox!.direction == AxisDirection.down
          ? false
          : true, // reverses the list to start at the bottom

      itemBuilder: buildItem,
    );

    if (widget.decoration!.hasScrollbar) {
      child = Scrollbar(child: child);
    }

    return child;
  }
}

/// Supply an instance of this class to the [TypeAhead.suggestionsBoxDecoration]
/// property to configure the suggestions box decoration
class SuggestionsBoxDecoration {
  /// The z-coordinate at which to place the suggestions box. This controls the size
  /// of the shadow below the box.
  ///
  /// Same as [Material.elevation](https://docs.flutter.io/flutter/material/Material/elevation.html)
  final double elevation;

  /// The color to paint the suggestions box.
  ///
  /// Same as [Material.color](https://docs.flutter.io/flutter/material/Material/color.html)
  final Color? color;

  /// Defines the material's shape as well its shadow.
  ///
  /// Same as [Material.shape](https://docs.flutter.io/flutter/material/Material/shape.html)
  final ShapeBorder? shape;

  /// Defines if a scrollbar will be displayed or not.
  final bool hasScrollbar;

  /// If non-null, the corners of this box are rounded by this [BorderRadius](https://docs.flutter.io/flutter/painting/BorderRadius-class.html).
  ///
  /// Same as [Material.borderRadius](https://docs.flutter.io/flutter/material/Material/borderRadius.html)
  final BorderRadius? borderRadius;

  /// The color to paint the shadow below the material.
  ///
  /// Same as [Material.shadowColor](https://docs.flutter.io/flutter/material/Material/shadowColor.html)
  final Color shadowColor;

  /// The constraints to be applied to the suggestions box
  final BoxConstraints? constraints;

  /// Creates a SuggestionsBoxDecoration
  const SuggestionsBoxDecoration(
      {this.elevation = 4.0,
      this.color,
      this.shape,
      this.hasScrollbar = true,
      this.borderRadius,
      this.shadowColor = const Color(0xFF000000),
      this.constraints});
}

/// Supply an instance of this class to the [TypeAhead.textFieldConfiguration]
/// property to configure the displayed text field
class TextFieldConfiguration<T> {
  /// The decoration to show around the text field.
  ///
  /// Same as [TextField.decoration](https://docs.flutter.io/flutter/material/TextField/decoration.html)
  final InputDecoration decoration;

  /// Controls the text being edited.
  ///
  /// If null, this widget will create its own [TextEditingController](https://docs.flutter.io/flutter/widgets/TextEditingController-class.html).
  /// A typical use case for this field in the TypeAhead widget is to set the
  /// text of the widget when a suggestion is selected. For example:
  ///
  /// ```dart
  /// final _controller = TextEditingController();
  /// ...
  /// ...
  /// TypeAheadField(
  ///   controller: _controller,
  ///   ...
  ///   ...
  ///   onSuggestionSelected: (suggestion) {
  ///     _controller.text = suggestion['city_name'];
  ///   }
  /// )
  /// ```
  final TextEditingController? controller;

  /// Controls whether this widget has keyboard focus.
  ///
  /// Same as [TextField.focusNode](https://docs.flutter.io/flutter/material/TextField/focusNode.html)
  final FocusNode? focusNode;

  /// The style to use for the text being edited.
  ///
  /// Same as [TextField.style](https://docs.flutter.io/flutter/material/TextField/style.html)
  final TextStyle? style;

  /// How the text being edited should be aligned horizontally.
  ///
  /// Same as [TextField.textAlign](https://docs.flutter.io/flutter/material/TextField/textAlign.html)
  final TextAlign textAlign;

  /// Same as [TextField.textDirection](https://docs.flutter.io/flutter/material/TextField/textDirection.html)
  ///
  /// Defaults to null
  final TextDirection? textDirection;

  /// If false the text field is "disabled": it ignores taps and its
  /// [decoration] is rendered in grey.
  ///
  /// Same as [TextField.enabled](https://docs.flutter.io/flutter/material/TextField/enabled.html)
  final bool enabled;

  /// The type of keyboard to use for editing the text.
  ///
  /// Same as [TextField.keyboardType](https://docs.flutter.io/flutter/material/TextField/keyboardType.html)
  final TextInputType keyboardType;

  /// Whether this text field should focus itself if nothing else is already
  /// focused.
  ///
  /// Same as [TextField.autofocus](https://docs.flutter.io/flutter/material/TextField/autofocus.html)
  final bool autofocus;

  /// Optional input validation and formatting overrides.
  ///
  /// Same as [TextField.inputFormatters](https://docs.flutter.io/flutter/material/TextField/inputFormatters.html)
  final List<TextInputFormatter>? inputFormatters;

  /// Whether to enable auto correction.
  ///
  /// Same as [TextField.autocorrect](https://docs.flutter.io/flutter/material/TextField/autocorrect.html)
  final bool autocorrect;

  /// {@macro flutter.widgets.editableText.minLines}
  final int? minLines;

  /// The maximum number of lines for the text to span, wrapping if necessary.
  ///
  /// Same as [TextField.maxLines](https://docs.flutter.io/flutter/material/TextField/maxLines.html)
  final int? maxLines;

  /// The maximum number of characters (Unicode scalar values) to allow in the
  /// text field.
  ///
  /// Same as [TextField.maxLength](https://docs.flutter.io/flutter/material/TextField/maxLength.html)
  final int? maxLength;

  /// If true, prevents the field from allowing more than [maxLength]
  /// characters.
  ///
  /// Same as [TextField.maxLengthEnforced](https://docs.flutter.io/flutter/material/TextField/maxLengthEnforced.html)
  final MaxLengthEnforcement maxLengthEnforcement;

  /// Whether to hide the text being edited (e.g., for passwords).
  ///
  /// Same as [TextField.obscureText](https://docs.flutter.io/flutter/material/TextField/obscureText.html)
  final bool? obscureText;

  /// Called when the text being edited changes.
  ///
  /// Same as [TextField.onChanged](https://docs.flutter.io/flutter/material/TextField/onChanged.html)
  final ValueChanged<String>? onChanged;

  /// Called when the user indicates that they are done editing the text in the
  /// field.
  ///
  /// Same as [TextField.onSubmitted](https://docs.flutter.io/flutter/material/TextField/onSubmitted.html)
  final ValueChanged<String>? onSubmitted;

  /// The color to use when painting the cursor.
  ///
  /// Same as [TextField.cursorColor](https://docs.flutter.io/flutter/material/TextField/cursorColor.html)
  final Color? cursorColor;

  /// How rounded the corners of the cursor should be. By default, the cursor has a null Radius
  ///
  /// Same as [TextField.cursorRadius](https://docs.flutter.io/flutter/material/TextField/cursorRadius.html)
  final Radius? cursorRadius;

  /// How thick the cursor will be.
  ///
  /// Same as [TextField.cursorWidth](https://docs.flutter.io/flutter/material/TextField/cursorWidth.html)
  final double cursorWidth;

  /// The appearance of the keyboard.
  ///
  /// Same as [TextField.keyboardAppearance](https://docs.flutter.io/flutter/material/TextField/keyboardAppearance.html)
  final Brightness? keyboardAppearance;

  /// Called when the user submits editable content (e.g., user presses the "done" button on the keyboard).
  ///
  /// Same as [TextField.onEditingComplete](https://docs.flutter.io/flutter/material/TextField/onEditingComplete.html)
  final VoidCallback? onEditingComplete;

  /// Configures padding to edges surrounding a Scrollable when the Text field scrolls into view.
  ///
  /// Same as [TextField.scrollPadding](https://docs.flutter.io/flutter/material/TextField/scrollPadding.html)
  final EdgeInsets scrollPadding;

  /// Configures how the platform keyboard will select an uppercase or lowercase keyboard.
  ///
  /// Same as [TextField.TextCapitalization](https://docs.flutter.io/flutter/material/TextField/textCapitalization.html)
  final TextCapitalization textCapitalization;

  /// The type of action button to use for the keyboard.
  ///
  /// Same as [TextField.textInputAction](https://docs.flutter.io/flutter/material/TextField/textInputAction.html)
  final TextInputAction? textInputAction;

  /// Callback that generates a custom [InputDecorator.counter] widget.
  ///
  /// See [InputCounterWidgetBuilder] for an explanation of the passed in
  /// arguments.  The returned widget will be placed below the line in place of
  /// the default widget built when [counterText] is specified.
  ///
  /// The returned widget will be wrapped in a [Semantics] widget for
  /// accessibility, but it also needs to be accessible itself.  For example,
  /// if returning a Text widget, set the [semanticsLabel] property.
  ///
  /// {@tool sample}
  /// ```dart
  /// Widget counter(
  ///   BuildContext context,
  ///   {
  ///     int currentLength,
  ///     int maxLength,
  ///     bool isFocused,
  ///   }
  /// ) {
  ///   return Text(
  ///     '$currentLength of $maxLength characters',
  ///     semanticsLabel: 'character count',
  ///   );
  /// }
  /// ```
  /// {@end-tool}
  final InputCounterWidgetBuilder? buildCounter;

  /// {@macro flutter.widgets.scrollable.dragStartBehavior}
  final DragStartBehavior? dragStartBehavior;

  /// {@macro flutter.widgets.editableText.enableInteractiveSelection}
  final bool? enableInteractiveSelection;

  /// {@macro flutter.services.textInput.enableSuggestions}
  final bool? enableSuggestions;

  /// {@macro flutter.widgets.editableText.expands}
  final bool? expands;

  /// {@macro flutter.widgets.editableText.readOnly}
  final bool? readOnly;

  /// {@macro flutter.widgets.editableText.scrollController}
  final ScrollController? scrollController;

  /// {@macro flutter.widgets.editableText.strutStyle}
  final StrutStyle? strutStyle;

  /// {@macro flutter.widgets.editableText.showCursor}
  final bool? showCursor;

  /// {@macro flutter.widgets.edtiableText.scrollPhysics}
  final ScrollPhysics? scrollPhysics;

  /// {@macro flutter.material.inputDecorator.textAlignVertical}
  final TextAlignVertical? textAlignVertical;

  /// Configuration of toolbar options.
  ///
  /// If not set, select all and paste will default to be enabled. Copy and cut
  /// will be disabled if [obscureText] is true. If [readOnly] is true,
  /// paste and cut will be disabled regardless.
  @Deprecated(
    'Use `contextMenuBuilder` instead. '
    'This feature was deprecated after v3.3.0-0.5.pre.',
  )
  final ToolbarOptions? toolbarOptions;
  final Iterable<String>? autofillHints;

  /// Creates a TextFieldConfiguration
  const TextFieldConfiguration({
    this.decoration = const InputDecoration(),
    this.autofillHints,
    this.style,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.obscureText = false,
    this.maxLengthEnforcement = MaxLengthEnforcement.enforced,
    this.maxLength,
    this.minLines,
    this.maxLines = 1,
    this.autocorrect = true,
    this.inputFormatters,
    this.autofocus = false,
    this.keyboardType = TextInputType.text,
    this.enabled = true,
    this.textAlign = TextAlign.start,
    this.focusNode,
    this.cursorColor,
    this.cursorRadius,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.cursorWidth = 2.0,
    this.keyboardAppearance,
    this.onEditingComplete,
    this.textDirection,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.buildCounter,
    this.dragStartBehavior,
    this.enableInteractiveSelection,
    this.enableSuggestions,
    this.expands,
    this.readOnly,
    this.scrollController,
    this.strutStyle,
    this.showCursor,
    this.scrollPhysics,
    this.textAlignVertical,
    this.toolbarOptions,
  });

  /// Copies the [TextFieldConfiguration] and only changes the specified
  /// properties
  TextFieldConfiguration<T> copyWith(
      {InputDecoration? decoration,
      TextStyle? style,
      TextEditingController? controller,
      ValueChanged<T>? onChanged,
      ValueChanged<T>? onSubmitted,
      bool? obscureText,
      MaxLengthEnforcement? maxLengthEnforcement,
      int? maxLength,
      int? minLines,
      int? maxLines,
      bool? autocorrect,
      List<TextInputFormatter>? inputFormatters,
      bool? autofocus,
      TextInputType? keyboardType,
      bool? enabled,
      TextAlign? textAlign,
      FocusNode? focusNode,
      Color? cursorColor,
      Radius? cursorRadius,
      double? cursorWidth,
      Brightness? keyboardAppearance,
      VoidCallback? onEditingComplete,
      EdgeInsets? scrollPadding,
      TextCapitalization? textCapitalization,
      TextDirection? textDirection,
      TextInputAction? textInputAction}) {
    return TextFieldConfiguration<T>(
        decoration: decoration ?? this.decoration,
        style: style ?? this.style,
        controller: controller ?? this.controller,
        onChanged: onChanged as void Function(String)? ?? this.onChanged,
        onSubmitted: onSubmitted as void Function(String)? ?? this.onSubmitted,
        obscureText: obscureText ?? this.obscureText,
        maxLengthEnforcement: maxLengthEnforcement ?? this.maxLengthEnforcement,
        maxLength: maxLength ?? this.maxLength,
        minLines: minLines ?? this.minLines,
        maxLines: maxLines ?? this.maxLines,
        autocorrect: autocorrect ?? this.autocorrect,
        inputFormatters: inputFormatters ?? this.inputFormatters,
        autofocus: autofocus ?? this.autofocus,
        keyboardType: keyboardType ?? this.keyboardType,
        enabled: enabled ?? this.enabled,
        textAlign: textAlign ?? this.textAlign,
        focusNode: focusNode ?? this.focusNode,
        cursorColor: cursorColor ?? this.cursorColor,
        cursorRadius: cursorRadius ?? this.cursorRadius,
        cursorWidth: cursorWidth ?? this.cursorWidth,
        keyboardAppearance: keyboardAppearance ?? this.keyboardAppearance,
        onEditingComplete: onEditingComplete ?? this.onEditingComplete,
        scrollPadding: scrollPadding ?? this.scrollPadding,
        textCapitalization: textCapitalization ?? this.textCapitalization,
        textInputAction: textInputAction ?? this.textInputAction,
        textDirection: textDirection ?? this.textDirection);
  }
}

class _SuggestionsBox {
  static const int waitMetricsTimeoutMillis = 1000;
  static const double minOverlaySpace = 64.0;

  final BuildContext context;
  final AxisDirection desiredDirection;
  final bool autoFlipDirection;

  OverlayEntry? _overlayEntry;
  AxisDirection direction;

  bool _isOpened = false;
  bool widgetMounted = true;
  double maxHeight = 300.0;
  double textBoxWidth = 100.0;
  double textBoxHeight = 100.0;
  late double directionUpOffset;

  _SuggestionsBox(this.context, this.direction, this.autoFlipDirection)
      : desiredDirection = direction;

  void open() {
    if (this._isOpened) return;
    assert(this._overlayEntry != null);
    Overlay.of(context).insert(this._overlayEntry!);
    this._isOpened = true;
  }

  void close() {
    if (!this._isOpened) return;
    assert(this._overlayEntry != null);
    this._overlayEntry!.remove();
    this._isOpened = false;
  }

  void toggle() {
    if (this._isOpened) {
      this.close();
    } else {
      this.open();
    }
  }

  MediaQuery? _findRootMediaQuery() {
    MediaQuery? rootMediaQuery;
    context.visitAncestorElements((element) {
      if (element.widget is MediaQuery) {
        rootMediaQuery = element.widget as MediaQuery;
      }
      return true;
    });

    return rootMediaQuery;
  }

  /// Delays until the keyboard has toggled or the orientation has fully changed
  Future<bool> _waitChangeMetrics() async {
    if (widgetMounted) {
      // initial viewInsets which are before the keyboard is toggled
      EdgeInsets initial = MediaQuery.of(context).viewInsets;
      // initial MediaQuery for orientation change
      MediaQuery? initialRootMediaQuery = _findRootMediaQuery();

      int timer = 0;
      // viewInsets or MediaQuery have changed once keyboard has toggled or orientation has changed
      while (widgetMounted && timer < waitMetricsTimeoutMillis) {
        // TODO: reduce delay if showDialog ever exposes detection of animation end
        await Future<void>.delayed(const Duration(milliseconds: 170));
        timer += 170;

        if (widgetMounted &&
            context.mounted &&
            (MediaQuery.of(context).viewInsets != initial ||
                _findRootMediaQuery() != initialRootMediaQuery)) {
          return true;
        }
      }
    }

    return false;
  }

  void resize() {
    // check to see if widget is still mounted
    // user may have closed the widget with the keyboard still open
    if (widgetMounted) {
      _adjustMaxHeightAndOrientation();
      _overlayEntry!.markNeedsBuild();
    }
  }

  // See if there's enough room in the desired direction for the overlay to display
  // correctly. If not, try the opposite direction if things look more roomy there
  void _adjustMaxHeightAndOrientation() {
    TypeAheadField widget = context.widget as TypeAheadField;

    RenderBox box = context.findRenderObject() as RenderBox;
    textBoxWidth = box.size.width;
    textBoxHeight = box.size.height;

    // top of text box
    double textBoxAbsY = box.localToGlobal(Offset.zero).dy;

    // height of window
    double windowHeight = MediaQuery.of(context).size.height;

    // we need to find the root MediaQuery for the unsafe area height
    // we cannot use BuildContext.ancestorWidgetOfExactType because
    // widgets like SafeArea creates a new MediaQuery with the padding removed
    MediaQuery rootMediaQuery = _findRootMediaQuery()!;

    // height of keyboard
    double keyboardHeight = rootMediaQuery.data.viewInsets.bottom;

    double maxHDesired = _calculateMaxHeight(desiredDirection, box, widget,
        windowHeight, rootMediaQuery, keyboardHeight, textBoxAbsY);

    // if there's enough room in the desired direction, update the direction and the max height
    if (maxHDesired >= minOverlaySpace || !autoFlipDirection) {
      direction = desiredDirection;
      maxHeight = maxHDesired;
    } else {
      // There's not enough room in the desired direction so see how much room is in the opposite direction
      AxisDirection flipped = flipAxisDirection(desiredDirection);
      double maxHFlipped = _calculateMaxHeight(flipped, box, widget,
          windowHeight, rootMediaQuery, keyboardHeight, textBoxAbsY);

      // if there's more room in this opposite direction, update the direction and maxHeight
      if (maxHFlipped > maxHDesired) {
        direction = flipped;
        maxHeight = maxHFlipped;
      }
    }

    if (maxHeight < 0) maxHeight = 0;
  }

  double _calculateMaxHeight(
      AxisDirection direction,
      RenderBox box,
      TypeAheadField widget,
      double windowHeight,
      MediaQuery rootMediaQuery,
      double keyboardHeight,
      double textBoxAbsY) {
    return direction == AxisDirection.down
        ? _calculateMaxHeightDown(box, widget, windowHeight, rootMediaQuery,
            keyboardHeight, textBoxAbsY)
        : _calculateMaxHeightUp(box, widget, windowHeight, rootMediaQuery,
            keyboardHeight, textBoxAbsY);
  }

  double _calculateMaxHeightDown(
      RenderBox box,
      TypeAheadField widget,
      double windowHeight,
      MediaQuery rootMediaQuery,
      double keyboardHeight,
      double textBoxAbsY) {
    // unsafe area, ie: iPhone X 'home button'
    // keyboardHeight includes unsafeAreaHeight, if keyboard is showing, set to 0
    double unsafeAreaHeight =
        keyboardHeight == 0 ? rootMediaQuery.data.padding.bottom : 0;

    return windowHeight -
        keyboardHeight -
        unsafeAreaHeight -
        textBoxHeight -
        textBoxAbsY -
        2 * widget.suggestionsBoxVerticalOffset;
  }

  double _calculateMaxHeightUp(
      RenderBox box,
      TypeAheadField widget,
      double windowHeight,
      MediaQuery rootMediaQuery,
      double keyboardHeight,
      double textBoxAbsY) {
    // recalculate keyboard absolute y value
    double keyboardAbsY = windowHeight - keyboardHeight;

    directionUpOffset = textBoxAbsY > keyboardAbsY
        ? keyboardAbsY - textBoxAbsY - widget.suggestionsBoxVerticalOffset
        : -widget.suggestionsBoxVerticalOffset;

    // unsafe area, ie: iPhone X notch
    double unsafeAreaHeight = rootMediaQuery.data.padding.top;

    return textBoxAbsY > keyboardAbsY
        ? keyboardAbsY -
            unsafeAreaHeight -
            2 * widget.suggestionsBoxVerticalOffset
        : textBoxAbsY -
            unsafeAreaHeight -
            2 * widget.suggestionsBoxVerticalOffset;
  }

  Future<void> onChangeMetrics() async {
    if (await _waitChangeMetrics()) {
      resize();
    }
  }
}

/// Supply an instance of this class to the [TypeAhead.suggestionsBoxController]
/// property to manually control the suggestions box
class SuggestionsBoxController {
  _SuggestionsBox? _suggestionsBox;

  /// Opens the suggestions box
  void open() {
    _suggestionsBox?.open();
  }

  /// Closes the suggestions box
  void close() {
    _suggestionsBox?.close();
  }

  /// Opens the suggestions box if closed and vice-versa
  void toggle() {
    _suggestionsBox?.toggle();
  }

  /// Recalculates the height of the suggestions box
  void resize() {
    _suggestionsBox?.resize();
  }
}
