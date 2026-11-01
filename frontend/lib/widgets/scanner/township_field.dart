import 'package:flutter/material.dart';
import 'package:frontend/dtos/township_suggestion.dart';
import 'package:frontend/services/township_service.dart';
import 'package:provider/provider.dart';

class TownshipField extends StatefulWidget {
  const new({super.key, required this.onSelected});

  final ValueChanged<TownshipSuggestionDto> onSelected;

  @override
  State<TownshipField> createState() => _TownshipFieldState();
}

class _TownshipFieldState extends State<TownshipField> {
  final _focusNode = FocusNode();
  final _textEditingController = TextEditingController();

  TownshipSuggestionDto? _selectedSuggestion;
  String? _error;

  @override
  Widget build(BuildContext context) {
    final townshipService = context.read<TownshipService>();
    return Autocomplete<TownshipSuggestionDto>(
      focusNode: _focusNode,
      textEditingController: _textEditingController,
      optionsBuilder: (textEditingValue) async {
        if (textEditingValue.text.trim().isEmpty) return [];
        if (_selectedSuggestion != null) return [];

        var suggestions = await townshipService.getSuggestions(
          textEditingValue.text,
        );
        return suggestions.take(10);
      },
      optionsViewBuilder: (context, onSelected, options) {
        return Material(
          elevation: 4,
          color: Theme.of(context).colorScheme.surfaceContainer,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 300),
            child: ListView.separated(
              separatorBuilder: (context, index) =>
                  Divider(height: 0, indent: 20, endIndent: 20),
              shrinkWrap: true,
              itemCount: options.length,
              itemBuilder: (context, index) {
                final option = options.elementAt(index);
                return ListTile(
                  selectedTileColor: Theme.of(context).colorScheme.surfaceDim,
                  title: Text(option.nom, overflow: .ellipsis),
                  subtitle: Text(
                    option.codesPostaux.join(', '),
                    overflow: .ellipsis,
                  ),
                  onTap: () => onSelected(option),
                );
              },
            ),
          ),
        );
      },
      fieldViewBuilder: (_, textEditingController, focusNode, _) {
        return TextField(
          controller: textEditingController,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: "Nom",
            border: const OutlineInputBorder(),
            errorText: _error,
          ),
          onChanged: (value) => setState(() {
            _selectedSuggestion = null;
          }),
          onTapOutside: (_) => validateField(),
          onSubmitted: (_) => validateField(),
        );
      },
      onSelected: (selection) {
        setState(() {
          _selectedSuggestion = selection;
        });
        validateField();
        widget.onSelected(selection);
        _textEditingController.text =
            "${selection.nom} (${selection.codesPostaux.join(', ')})";
        _focusNode.unfocus();
      },
    );
  }

  void validateField() => _selectedSuggestion == null
      ? setState(() {
          _error = "Commune invalide";
        })
      : setState(() {
          _error = null;
        });
}
