/// This interface must be implemented by widgets which should be used
/// in [CWDynamicContainer] widget.
///
/// The returned controller in `createController()` must have a `text` property.
abstract class CWBase<T> {
  T copy(controller);
  dynamic createController();
  get id;
}
