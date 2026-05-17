defmodule Alexandria.Core do
  use Ash.Domain,
    otp_app: :alexandria,
    extensions: [Alexandria.FragmentExtension, AshPhoenix]

  resources do
    resource Alexandria.Core.Category do
      define :list_root_categories, action: :list_roots
      define :list_child_categories, action: :list_children, args: [:parent_id]
      define :get_category, action: :read, get_by: [:slug]
      define :create_root_category, action: :create_root
      define :create_child_category, action: :create_child
      define :rename_category, action: :rename
      define :recolor_category, action: :recolor
      define :reorder_category, action: :reorder
      define :set_category_metainfo, action: :set_metainfo
      define :destroy_category, action: :destroy
    end

    resource Alexandria.Core.Tag do
      define :list_tags, action: :read
      define :get_tag, action: :read, get_by: [:slug]
      define :create_tag, action: :create
      define :rename_tag, action: :rename
      define :join_tag_synonym_group, action: :join_synonym_group
      define :leave_tag_synonym_group, action: :leave_synonym_group
      define :destroy_tag, action: :destroy
    end

    resource Alexandria.Core.TagSynonymGroup do
      define :list_tag_synonym_groups, action: :read
      define :get_tag_synonym_group, action: :read, get_by: [:id]
      define :create_tag_synonym_group, action: :create
      define :rename_tag_synonym_group, action: :rename
      define :destroy_tag_synonym_group, action: :destroy
    end

    resource Alexandria.Core.Mark do
      define :list_marks, action: :read
      define :get_mark, action: :read, get_by: [:slug]
      define :create_mark, action: :create
      define :rename_mark, action: :rename
      define :destroy_mark, action: :destroy
    end

    resource Alexandria.Core.Document do
      define :list_documents, action: :read
      define :list_documents_by_category, action: :list_by_category, args: [:category_id]

      define :list_active_documents_by_category,
        action: :list_active_by_category,
        args: [:category_id]

      define :list_documents_by_tag, action: :by_tag, args: [:tag_id]
      define :list_documents_by_mark, action: :by_mark, args: [:mark_id]
      define :list_active_documents_by_tag, action: :list_active_by_tag, args: [:tag_id]
      define :list_active_documents_by_mark, action: :list_active_by_mark, args: [:mark_id]
      define :list_documents_by_ids, action: :list_by_ids, args: [:ids]
      define :get_document, action: :read, get_by: [:id]
      define :create_document, action: :create
      define :upload_document, action: :upload
      define :rename_document, action: :rename
      define :edit_document_description, action: :edit_description
      define :set_document_date, action: :set_date
      define :move_document_to_category, action: :move_to_category
      define :set_document_metainfo, action: :set_metainfo
      define :add_tag_to_document, action: :add_tag
      define :remove_tag_from_document, action: :remove_tag
      define :add_mark_to_document, action: :add_mark
      define :remove_mark_from_document, action: :remove_mark
      define :archive_document, action: :archive
      define :restore_document, action: :restore
      define :destroy_document, action: :destroy

      define :update_document_title_description_date, action: :update_title_description_date
    end

    resource Alexandria.Core.File do
      define :list_files_for_document, action: :for_document, args: [:document_id]
      define :get_file, action: :read, get_by: [:id]
      define :upload_original_file, action: :upload_original
      define :upload_thumbnail_file, action: :upload_thumbnail
      define :upload_rendering_file, action: :upload_rendering
      define :rename_file, action: :rename
      define :replace_file_content, action: :replace_content
      define :destroy_file, action: :destroy
      define :file_download_url, action: :download_url, args: [:id]
    end

    resource Alexandria.Core.DocumentTag
    resource Alexandria.Core.DocumentMark
  end
end
