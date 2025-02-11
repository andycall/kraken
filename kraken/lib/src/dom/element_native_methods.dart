import 'package:kraken/dom.dart';
import 'package:kraken/bridge.dart';
import 'dart:ffi';

final Pointer<NativeFunction<Native_GetViewModuleProperty>> nativeGetViewModuleProperty = Pointer.fromFunction(ElementNativeMethods._getViewModuleProperty, 0.0);
final Pointer<NativeFunction<Native_SetViewModuleProperty>> nativeSetViewModuleProperty = Pointer.fromFunction(ElementNativeMethods._setViewModuleProperty);
final Pointer<NativeFunction<Native_GetBoundingClientRect>> nativeGetBoundingClientRect =
    Pointer.fromFunction(ElementNativeMethods._getBoundingClientRect);
final Pointer<NativeFunction<Native_GetStringValueProperty>> nativeGetStringValueProperty =
Pointer.fromFunction(ElementNativeMethods._getStringValueProperty);
final Pointer<NativeFunction<Native_Click>> nativeClick = Pointer.fromFunction(ElementNativeMethods._click);
final Pointer<NativeFunction<Native_Scroll>> nativeScroll = Pointer.fromFunction(ElementNativeMethods._scroll);
final Pointer<NativeFunction<Native_ScrollBy>> nativeScrollBy = Pointer.fromFunction(ElementNativeMethods._scrollBy);

// https://www.w3.org/TR/cssom-view-1/
enum ViewModuleProperty {
  offsetTop,
  offsetLeft,
  offsetWidth,
  offsetHeight,
  clientWidth,
  clientHeight,
  clientTop,
  clientLeft,
  scrollTop,
  scrollLeft,
  scrollHeight,
  scrollWidth
}

mixin ElementNativeMethods on Node {

  static double _getViewModuleProperty(Pointer<NativeElement> nativeElement, int property) {
    Element element = Element.getElementOfNativePtr(nativeElement);
    element.flushLayout();
    ViewModuleProperty kind = ViewModuleProperty.values[property];
    switch(kind) {
      case ViewModuleProperty.offsetTop:
        return element.getOffsetY();
      case ViewModuleProperty.offsetLeft:
        return element.getOffsetX();
      case ViewModuleProperty.offsetWidth:
        return element.renderBoxModel.hasSize ? element.renderBoxModel.size.width : 0;
      case ViewModuleProperty.offsetHeight:
        return element.renderBoxModel.hasSize ? element.renderBoxModel.size.height : 0;
      case ViewModuleProperty.clientWidth:
        return element.renderBoxModel.clientWidth;
      case ViewModuleProperty.clientHeight:
        return element.renderBoxModel.clientHeight;
      case ViewModuleProperty.clientTop:
        return element.renderBoxModel.renderStyle.borderTop;
      case ViewModuleProperty.clientLeft:
        return element.renderBoxModel.renderStyle.borderLeft;
      case ViewModuleProperty.scrollTop:
        return element.scrollTop;
      case ViewModuleProperty.scrollLeft:
        return element.scrollLeft;
      case ViewModuleProperty.scrollHeight:
        return element.scrollHeight;
      case ViewModuleProperty.scrollWidth:
        return element.scrollWidth;
    }
    return 0.0;
  }

  static void _setViewModuleProperty(Pointer<NativeElement> nativeElement, int property, double value) {
    Element element = Element.getElementOfNativePtr(nativeElement);
    element.flushLayout();

    ViewModuleProperty kind = ViewModuleProperty.values[property];

    switch(kind) {
      case ViewModuleProperty.scrollTop:
        element.scrollTop = value;
        break;
      case ViewModuleProperty.scrollLeft:
        element.scrollLeft = value;
        break;
      default:
        break;
    }
  }

  static Pointer<NativeBoundingClientRect> _getBoundingClientRect(Pointer<NativeElement> nativeElement) {
    Element element = Element.getElementOfNativePtr(nativeElement);
    element.flushLayout();
    return element.boundingClientRect.toNative();
  }

  static Pointer<NativeString> _getStringValueProperty(Pointer<NativeElement> nativeElement, Pointer<NativeString> property) {
    Element element = Element.getElementOfNativePtr(nativeElement);
    element.flushLayout();
    String key = nativeStringToString(property);
    var value = element.getProperty(key);
    String valueInString = value == null ? '' : value.toString();
    return stringToNativeString(valueInString);
  }

  static void _click(Pointer<NativeElement> nativeElement) {
    Element element = Element.getElementOfNativePtr(nativeElement);
    element.flushLayout();
    element.handleMethodClick();
  }

  static void _scroll(Pointer<NativeElement> nativeElement, int x, int y) {
    Element element = Element.getElementOfNativePtr(nativeElement);
    element.flushLayout();
    element.handleMethodScroll(x, y);
  }

  static void _scrollBy(Pointer<NativeElement> nativeElement, int x, int y) {
    Element element = Element.getElementOfNativePtr(nativeElement);
    element.flushLayout();
    element.handleMethodScroll(x, y, diff: true);
  }

  void bindNativeMethods(Pointer<NativeElement> nativeElement) {
    if (nativeElement == nullptr) return;
    nativeElement.ref.getViewModuleProperty = nativeGetViewModuleProperty;
    nativeElement.ref.setViewModuleProperty = nativeSetViewModuleProperty;
    nativeElement.ref.getBoundingClientRect = nativeGetBoundingClientRect;
    nativeElement.ref.getStringValueProperty = nativeGetStringValueProperty;
    nativeElement.ref.click = nativeClick;
    nativeElement.ref.scroll = nativeScroll;
    nativeElement.ref.scrollBy = nativeScrollBy;
  }
}
